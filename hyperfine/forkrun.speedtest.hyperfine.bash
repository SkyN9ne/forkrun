
############################################## BEGIN CODE ##############################################

SECONDS=0
shopt -s extglob

renice --priority -20 --pid $$

declare -F forkrun 1>/dev/null 2>&1 || { 
    [[ -f ./forkrun.bash ]] || wget  https://raw.githubusercontent.com/jkool702/forkrun/forkrun-testing/forkrun.bash
    . ./forkrun.bash
}

findDirDefault='/usr'

[[ -n "$1" ]] && [[ -d "$1" ]] && findDir="$1"
: ${findDir:="${findDirDefault}"} ${ramdiskTransferFlag:=true}

findDir="$(realpath "${findDir}")"
findDir="${findDir%/}"

if ${ramdiskTransferFlag}; then

    grep -qF 'tmpfs /mnt/ramdisk' </proc/mounts || {
        printf '\nMOUNTING RAMDISK AT /mnt/ramdisk\n' >&2
        mkdir -p /mnt/ramdisk
        sudo mount -t tmpfs tmpfs /mnt/ramdisk
        sudo chown -R "$USER": /mnt/ramdisk
    }
    
    printf '\nCOPYING FILES FROM %s TO RAMDISK AT %s\n' "${findDir}" "/mnt/ramdisk/${findDir#/}" >&2
    mkdir -p "/mnt/ramdisk/${findDir}"
#    rsync -a "${findDir}"/* "/mnt/ramdisk/${findDir#/}"
#    \rm  -rf ./usr/lib64/dri
    
    findDir="/mnt/ramdisk/${findDir#/}"
    hfdir='/mnt/ramdisk/hyperfine'

else

  hfdir="${PWD}/hyperfine"

fi
"${testParallelFlag:=true}"

mkdir -p "${hfdir}"/{results,file_lists}

for kk in {1..6}; do
    find "${findDir}" -type f | head -n $(( 10 ** $kk )) >"${hfdir}"/file_lists/f${kk}
done

for kk in {1..6}; do 
    printf '\n-------------------------------- %s values --------------------------------\n\n' $(wc -l <"${hfdir}"/file_lists/f${kk}); 

    for c in  sha1sum sha256sum sha512sum sha224sum sha384sum md5sum  "sum -s" "sum -r" cksum b2sum "cksum -a sm3"; do 
        printf '\n---------------- %s ----------------\n\n' "$c"; 

        if ${testParallelFlag}; then
           hyperfine -w 1 -i --shell /usr/bin/bash --parameter-list cmd 'source '"${PWD}"'/forkrun.bash && forkrun --','xargs -P '"$(nproc)"' -d $'"'"'\n'"'"' --','parallel -m --' --export-json ""${hfdir}"/results/forkrun.${c// /_}.f${kk}.hyperfine.results" --style=full --setup 'shopt -s extglob' --prepare 'renice --priority -20 --pid $$' '{cmd} '"${c}"' <'"${hfdir}"'/file_lists/f'"${kk}" 
        else
            hyperfine -w 1 -i --shell /usr/bin/bash --parameter-list cmd 'source '"${PWD}"'/forkrun.bash && forkrun --','xargs -P '"$(nproc)"' -d $'"'"'\n'"'"' --' --export-json ""${hfdir}"/results/forkrun.${c// /_}.f${kk}.hyperfine.results" --style=full --setup 'shopt -s extglob' --prepare 'renice --priority -20 --pid $$' '{cmd} '"${c}"' <'"${hfdir}"'/file_lists/f'"${kk}" 
        fi

    done
done | tee -a "${hfdir}"/results/forkrun.stdout.results

for t in '"min"' '"mean"' '"max"'; do
    printf '\n-----------------------------------------------------\n-------------------- %s TIMES --------------------\n-----------------------------------------------------\n\n' "$t"
    printf '%0.11s    \t' '#' sha1sum sha1sum sha256sum sha256sum sha512sum sha512sum sha224sum sha224sum sha384sum sha384sum md5sum md5sum  "sum -s" "sum -s" "sum -r" "sum -r" cksum cksum b2sum b2sum "cksum -a sm3" "cksum -a sm3" 
    printf '\n(stdin)\t'; 
    for kk in {1..11}; do printf '%0.12s    \t' '(forkrun)' '(xargs)'; done; 
        printf '\n\n'; 
        for kk in {1..6}; do
            printf '%s\t' $(wc -l <"${hfdir}"/file_lists/f$kk)
            for c in sha1sum sha256sum sha512sum sha224sum sha384sum md5sum  "sum -s" "sum -r" cksum b2sum "cksum -a sm3"; do
            printf '%0.12s\t' $(grep -F "$t" < "${hfdir}"/results/forkrun."${c// /_}".f${kk}.hyperfine.results | sed -E s/'^.*\:'//)
        done
        printf '\n'
    done
done

shopt -s extglob

printf0() {
    local -a val pad
    local nn nn1 padStr 
    local -i kk padMax padLast

    padMax=0
    padLast=0

    for nn in "$@"; do
        nn1="${nn//[, ]/}"
        
        if [[ "$nn1" == *\:* ]]; then
            val+=("${nn##*\:}")
            pad+=("$(( ${nn%%\:*} - ${#val[-1]} ))")
            padLast=${nn%%\:*}
        else
            val+=(${nn})
            pad+=("$(( ${padLast} - ${#val[-1]} ))")
        fi

        (( ${pad[-1]} < 0 )) && pad[-1]=0
        (( ${pad[-1]} > ${padMax} )) && padMax=${pad[-1]}
    done

    padStr="$(source /proc/self/fd/0 <<<"printf '%.0s ' {1..${padMax}}")"

    for kk in ${!val[@]}; do
        val[$kk]+="${padStr:0:${pad[$kk]}}"
    done

    printf '%s\t' "${val[@]}"

}

myAdd() {
    local -a v1 v0
    local -i kk maxLen V0 V1
    local zeroAdd 

    shopt -s extglob

    v1=("${@%%.*}")
    v0=("${@##*.}")

    maxLen=0
    for kk in "${!v0[@]}"; do
        (( ${#v0[$kk]} > ${maxLen} )) && maxLen=${#v0[$kk]}
    done

    zeroAdd="$(source /proc/self/fd/0 <<<"printf '0%.0s' {1..${maxLen}}")"

    for kk in "${!v0[@]}"; do
        v0[$kk]="${v0[$kk]}${zeroAdd:${#v0[$kk]}}"
    done

    v0=("${v0[@]##*(0)}")

    V1=$(( ${v1[0]} $(printf ' + %s' "${v1[@]:1}") ))
    V0=$(( ${v0[0]} $(printf ' + %s' "${v0[@]:1}") ))

    until (( ${V0} < ( 10 ** ${maxLen} ) )); do
        V0=$(( ${V0} - ( 10 ** ${maxLen} ) ))
        ((V1++))
    done

    printf '%s.%s\n' "${V1}" "${V0}"
 
}

{
printf '\n\n||-----------------------------------------------------------------||\n||-----------------------RUN_TIME_IN_SECONDS-----------------------||\n||-----------------------------------------------------------------||\n'  

for kk in {1..6}; do

    printf '\n\n\n||--------------------------------------------------------NUM_CHECKSUMS=%s--------------------------------------------------------------------------------|| \n\n' $(wc -l <"${hfdir}/file_lists/f${kk}")
    printf0 8:'(algorithm)' 
    if ${testParallelFlag}; then
        printf0 12:'  (forkrun)' 12:'   (xargs)' 12:'  (parallel)' 50:'(relative performance vs xargs)' 50:'(relative performance vs parallel)'
    else
        printf0 12:'  (forkrun)' 12:'   (xargs)' 38:'    (relative performance)'
    fi
    printf '\n%s\t' '------------'
    if ${testParallelFlag}; then
        printf0 12:'------------' '------------' '------------' 50:'--------------------------------' 50:'--------------------------------'
    else
        printf0 12:'------------' '------------' 38:'--------------------------------'
    fi
    printf '\n'
    declare +i -a A 
    T0=0.0
    T1=0.0
    ${testParallelFlag} && T2=0.0
    for c in sha1sum sha256sum sha512sum sha224sum sha384sum md5sum  "sum -s" "sum -r" cksum b2sum "cksum -a sm3"; do
        printf0 12:"${c}"
            mapfile -t A < <(grep -F "mean" < "${hfdir}"/results/forkrun."${c// /_}".f${kk}.hyperfine.results | sed -E s/'^.*\:'//)
            A=("${A[@]%%*([ ,])}")
            A=("${A[@]##*( )}")
           
            printf0 12:$(printf '%.12s ' "${A[@]}")
            mapfile -t -d $'\t' A < <(printf0 12:$(printf '%.12s ' "${A[@]}"))
            A=("${A[@]//\ /0}")
            T0="$(myAdd "${T0}" "${A[0]}")"
            T1="$(myAdd "${T1}" "${A[1]}")"
            ${testParallelFlag} && T2="$(myAdd "${T2}" "${A[2]}")"

            A1=("${A[@]%%.*}")
            A0=("${A[@]##*.}")

            A_min=${#A0[0]}
            (( ${#A0[1]} < $A_min )) && A_min=${#A0[1]}
            ${testParallelFlag} && (( ${#A0[2]} < $A_min )) && A_min=${#A0[2]}

            if ${testParallelFlag}; then
                A=("${A1[0]}.${A0[0]:0:${A_min}}" "${A1[1]}.${A0[1]:0:${A_min}}" "${A1[2]}.${A0[2]:0:${A_min}}")
            else
                A=("${A[0]:0:${A_min}}" "${A[1]:0:${A_min}}")
            fi
            
            A=("${A[@]##*([0\.\(\:\)\,])}")
            A=("${A[@]//./}")
            A=("${A[@]##*([0\.\(\:\)\,])}")
            if (( ${A[0]} < ${A[1]} )); then
                ratio="$(( ( ( 10000 * ${A[1]//./} ) / ${A[0]//./} ) ))"
                printf0 $(${testParallelFlag} && printf '44' || printf '38'):"$(printf 'forkrun is %s%% faster '"$(${testParallelFlag} && printf 'than xargs ')"'(%s.%sx)' "$(( ( $ratio / 100 ) - 100 ))" "${ratio:0:$(( ${#ratio} - 4 ))}" "${ratio:$(( ${#ratio} - 4 ))}")"
            else
                ratio="$(( ( ( 10000 * ${A[0]//./} ) / ${A[1]//./} ) ))"
                printf0 $(${testParallelFlag} && printf '44' || printf '38'):"$(printf 'xargs is %s%% faster '"$(${testParallelFlag} && printf 'than forkrun ')"'(%s.%sx)' "$(( ( $ratio / 100 ) - 100 ))" "${ratio:0:$(( ${#ratio} - 4 ))}" "${ratio:$(( ${#ratio} - 4 ))}")"
            fi
            if ${testParallelFlag}; then
                if (( ${A[0]} < ${A[2]} )); then
                    ratio1="$(( ( ( 10000 * ${A[2]//./} ) / ${A[0]//./} ) ))"
                    printf0 44:"$(printf 'forkrun is %s%% faster than parallel (%s.%sx)' "$(( ( $ratio1 / 100 ) - 100 ))" "${ratio1:0:$(( ${#ratio1} - 4 ))}" "${ratio1:$(( ${#ratio1} - 4 ))}")"
                else
                    ratio1="$(( ( ( 10000 * ${A[0]//./} ) / ${A[2]//./} ) ))"
                    printf0 44:"$(printf 'parallel is %s%% faster than forkrun (%s.%sx)' "$(( ( $ratio1 / 100 ) - 100 ))" "${ratio1:0:$(( ${#ratio1} - 4 ))}" "${ratio1:$(( ${#ratio1} - 4 ))}")"
                fi
            fi
            printf '\n'
    done
    printf '\n'
    if ${testParallelFlag}; then
        Ta=(${T0} ${T1} ${T2})
    else
        Ta=(${T0} ${T1})
    fi
    printf0 12:OVERALL  $(printf '%.12s ' "${Ta[@]}")
    Ta1=("${Ta[@]%%.*}")
    Ta0=("${Ta[@]##*.}")

    Ta_min=${#Ta0[0]}
    (( ${#Ta0[1]} < $Ta_min )) && Ta_min=${#Ta0[1]}
    ${testParallelFlag} && (( ${#Ta0[2]} < $Ta_min )) && Ta_min=${#Ta0[2]}

    if ${testParallelFlag}; then
        Ta=("${Ta1[0]}.${Ta0[0]:0:${Ta_min}}" "${Ta1[1]}.${Ta0[1]:0:${Ta_min}}" "${Ta1[2]}.${Ta0[2]:0:${Ta_min}}")
    else
        Ta=("${Ta[0]:0:${Ta_min}}" "${Ta[1]:0:${Ta_min}}")
    fi
    
    Ta=("${Ta[@]##*([0\.\(\:\)\,])}")
    Ta=("${Ta[@]//./}")
    Ta=("${Ta[@]##*([0\.\(\:\)\,])}")
    if (( ${Ta[0]} < ${Ta[1]} )); then
        ratio2="$(( ( ( 10000 * ${Ta[1]//./} ) / ${Ta[0]//./} ) ))"
        printf0 $(${testParallelFlag} && printf '44' || printf '38'):"$(printf 'forkrun is %s%% faster '"$(${testParallelFlag} && printf 'than xargs ')"'(%s.%sx)' "$(( ( $ratio2 / 100 ) - 100 ))" "${ratio2:0:$(( ${#ratio2} - 4 ))}" "${ratio2:$(( ${#ratio2} - 4 ))}")"
    else
        ratio2="$(( ( ( 10000 * ${Ta[0]//./} ) / ${Ta[1]//./} ) ))"
        printf0 $(${testParallelFlag} && printf '44' || printf '38'):"$(printf 'xargs is %s%% faster '"$(${testParallelFlag} && printf 'than forkrun ')"'(%s.%sx)' "$(( ( $ratio2 / 100 ) - 100 ))" "${ratio2:0:$(( ${#ratio2} - 4 ))}" "${ratio2:$(( ${#ratio2} - 4 ))}")"
    fi
    if ${testParallelFlag}; then
        if (( ${Ta[0]} < ${Ta[2]} )); then
            ratio2="$(( ( ( 10000 * ${Ta[2]//./} ) / ${Ta[0]//./} ) ))"
            printf0 44:"$(printf 'forkrun is %s%% faster than parallel (%s.%sx)' "$(( ( $ratio2 / 100 ) - 100 ))" "${ratio2:0:$(( ${#ratio2} - 4 ))}" "${ratio2:$(( ${#ratio2} - 4 ))}")"
        else
            ratio2="$(( ( ( 10000 * ${Ta[0]//./} ) / ${Ta[2]//./} ) ))"
            printf0 44:"$(printf 'parallel is %s%% faster than forkrun (%s.%sx)' "$(( ( $ratio2 / 100 ) - 100 ))" "${ratio2:0:$(( ${#ratio2} - 4 ))}" "${ratio2:$(( ${#ratio2} - 4 ))}")"
        fi
    fi
    printf '\n'
done
} | tee "${hfdir}"/results/results-table

# RESULTS
:<<'EOF'
||-----------------------------------------------------------------||
||-----------------------RUN_TIME_IN_SECONDS-----------------------||
||-----------------------------------------------------------------||



||--------------------------------------------------------NUM_CHECKSUMS=10--------------------------------------------------------------------------------|| 

(algorithm)       (forkrun)        (xargs)        (parallel)    (relative performance vs xargs)                         (relative performance vs parallel)                
------------    ------------    ------------    ------------    --------------------------------                        --------------------------------                  
sha1sum         0.0221667247    0.0018750129    0.1630903451    xargs is 1082% faster than forkrun (11.8221x)   forkrun is 635% faster than parallel (7.3574x)
sha256sum       0.0222077711    0.0019181561    0.1629461111    xargs is 1057% faster than forkrun (11.5776x)   forkrun is 633% faster than parallel (7.3373x)
sha512sum       0.0222074076    0.0019584463    0.1629756567    xargs is 1033% faster than forkrun (11.3392x)   forkrun is 633% faster than parallel (7.3387x)
sha224sum       0.0222283172    0.0019137923    0.1629487807    xargs is 1061% faster than forkrun (11.6148x)   forkrun is 633% faster than parallel (7.3306x)
sha384sum       0.0221844371    0.0019296681    0.1628500374    xargs is 1049% faster than forkrun (11.4965x)   forkrun is 634% faster than parallel (7.3407x)
md5sum          0.0221686970    0.0018695627    0.1630133621    xargs is 1085% faster than forkrun (11.8576x)   forkrun is 635% faster than parallel (7.3533x)
sum -s          0.0217999997    0.0014598752    0.1632813774    xargs is 1393% faster than forkrun (14.9327x)   forkrun is 648% faster than parallel (7.4899x)
sum -r          0.0218931983    0.0014866485    0.1630489127    xargs is 1372% faster than forkrun (14.7265x)   forkrun is 644% faster than parallel (7.4474x)
cksum           0.0222643711    0.0018542016    0.1634326655    xargs is 1100% faster than forkrun (12.0075x)   forkrun is 634% faster than parallel (7.3405x)
b2sum           0.0218908087    0.0015843474    0.1626443482    xargs is 1281% faster than forkrun (13.8169x)   forkrun is 642% faster than parallel (7.4298x)
cksum -a sm3    0.0223199789    0.0019613777    0.1641205825    xargs is 1037% faster than forkrun (11.3797x)   forkrun is 635% faster than parallel (7.3530x)

OVERALL         0.4428322337    0.2054373659    1.7943521794    xargs is 115% faster than forkrun (2.1555x)     forkrun is 305% faster than parallel (4.0519x)



||--------------------------------------------------------NUM_CHECKSUMS=100--------------------------------------------------------------------------------|| 

(algorithm)       (forkrun)        (xargs)        (parallel)    (relative performance vs xargs)                         (relative performance vs parallel)                
------------    ------------    ------------    ------------    --------------------------------                        --------------------------------                  
sha1sum         0.0236063838    0.0032121754    0.1946000551    xargs is 634% faster than forkrun (7.3490x)     forkrun is 724% faster than parallel (8.2435x)
sha256sum       0.0237318664    0.0036711432    0.1948226050    xargs is 546% faster than forkrun (6.4644x)     forkrun is 720% faster than parallel (8.2093x)
sha512sum       0.0237410334    0.0040142447    0.1948108999    xargs is 491% faster than forkrun (5.9141x)     forkrun is 720% faster than parallel (8.2056x)
sha224sum       0.0236955990    0.0036124260    0.1949263404    xargs is 555% faster than forkrun (6.5594x)     forkrun is 722% faster than parallel (8.2262x)
sha384sum       0.0237501755    0.0037770810    0.1948383579    xargs is 528% faster than forkrun (6.2879x)     forkrun is 720% faster than parallel (8.2036x)
md5sum          0.0235624059    0.0032311641    0.1946859117    xargs is 629% faster than forkrun (7.2922x)     forkrun is 726% faster than parallel (8.2625x)
sum -s          0.0227479824    0.0024039088    0.1950978508    xargs is 846% faster than forkrun (9.4629x)     forkrun is 757% faster than parallel (8.5764x)
sum -r          0.0228154072    0.0026705416    0.1947380948    xargs is 754% faster than forkrun (8.5433x)     forkrun is 753% faster than parallel (8.5353x)
cksum           0.0235367491    0.0027115275    0.1947627362    xargs is 768% faster than forkrun (8.6802x)     forkrun is 727% faster than parallel (8.2748x)
b2sum           0.0230250437    0.0035562619    0.1939956931    xargs is 547% faster than forkrun (6.4745x)     forkrun is 742% faster than parallel (8.4254x)
cksum -a sm3    0.0238663818    0.0041171368    0.1965976060    xargs is 479% faster than forkrun (5.7968x)     forkrun is 723% faster than parallel (8.2374x)

OVERALL         0.4705364824    0.3549829756    2.1438761509    xargs is 32% faster than forkrun (1.3255x)      forkrun is 355% faster than parallel (4.5562x)



||--------------------------------------------------------NUM_CHECKSUMS=1000--------------------------------------------------------------------------------|| 

(algorithm)       (forkrun)        (xargs)        (parallel)    (relative performance vs xargs)                         (relative performance vs parallel)                
------------    ------------    ------------    ------------    --------------------------------                        --------------------------------                  
sha1sum         0.0447829312    0.0367322309    0.2632289219    xargs is 21% faster than forkrun (1.2191x)      forkrun is 487% faster than parallel (5.8778x)
sha256sum       0.0647563532    0.0630272988    0.2817073755    xargs is 2% faster than forkrun (1.0274x)       forkrun is 335% faster than parallel (4.3502x)
sha512sum       0.0536621067    0.0534120224    0.2706735149    xargs is 0% faster than forkrun (1.0046x)       forkrun is 404% faster than parallel (5.0440x)
sha224sum       0.0637885819    0.0623672503    0.2816683651    xargs is 2% faster than forkrun (1.0227x)       forkrun is 341% faster than parallel (4.4156x)
sha384sum       0.0529855717    0.0508655843    0.2707261615    xargs is 4% faster than forkrun (1.0416x)       forkrun is 410% faster than parallel (5.1094x)
md5sum          0.0517946585    0.0448830329    0.2697468577    xargs is 15% faster than forkrun (1.1539x)      forkrun is 420% faster than parallel (5.2080x)
sum -s          0.0281302711    0.0162159577    0.2510356668    xargs is 73% faster than forkrun (1.7347x)      forkrun is 792% faster than parallel (8.9240x)
sum -r          0.0486180130    0.0432906465    0.2702369043    xargs is 12% faster than forkrun (1.1230x)      forkrun is 455% faster than parallel (5.5583x)
cksum           0.0286967624    0.0142509492    0.2483583623    xargs is 101% faster than forkrun (2.0136x)     forkrun is 765% faster than parallel (8.6545x)
b2sum           0.0456298664    0.0488122635    0.2670418882    forkrun is 6% faster than xargs (1.0697x)       forkrun is 485% faster than parallel (5.8523x)
cksum -a sm3    0.0951422082    0.1024677217    0.3124894991    forkrun is 7% faster than xargs (1.0769x)       forkrun is 228% faster than parallel (3.2844x)

OVERALL         0.9810337051    0.8669150363    4.1731633926    xargs is 13% faster than forkrun (1.1316x)      forkrun is 325% faster than parallel (4.2538x)



||--------------------------------------------------------NUM_CHECKSUMS=10000--------------------------------------------------------------------------------|| 

(algorithm)       (forkrun)        (xargs)        (parallel)    (relative performance vs xargs)                         (relative performance vs parallel)                
------------    ------------    ------------    ------------    --------------------------------                        --------------------------------                  
sha1sum         0.7068868947    1.2371532120    1.3615521273    forkrun is 75% faster than xargs (1.7501x)      forkrun is 92% faster than parallel (1.9261x)
sha256sum       1.4254721642    2.5174737736    2.4808952115    forkrun is 76% faster than xargs (1.7660x)      forkrun is 74% faster than parallel (1.7404x)
sha512sum       0.9867826465    1.7589091023    1.8159882173    forkrun is 78% faster than xargs (1.7824x)      forkrun is 84% faster than parallel (1.8403x)
sha224sum       1.4230787006    2.5033083044    2.4817792528    forkrun is 75% faster than xargs (1.7590x)      forkrun is 74% faster than parallel (1.7439x)
sha384sum       0.9869722366    1.7495862818    1.8055435852    forkrun is 77% faster than xargs (1.7726x)      forkrun is 82% faster than parallel (1.8293x)
md5sum          0.9517106087    1.6826772677    1.7565612520    forkrun is 76% faster than xargs (1.7680x)      forkrun is 84% faster than parallel (1.8456x)
sum -s          0.1717381569    0.2925260065    0.5516866713    forkrun is 70% faster than xargs (1.7033x)      forkrun is 221% faster than parallel (3.2123x)
sum -r          0.9733280035    1.7119362551    1.7831547264    forkrun is 75% faster than xargs (1.7588x)      forkrun is 83% faster than parallel (1.8320x)
cksum           0.1310715757    0.2119448126    0.5510956006    forkrun is 61% faster than xargs (1.6170x)      forkrun is 320% faster than parallel (4.2045x)
b2sum           0.8708479121    1.5570632172    1.6286356189    forkrun is 78% faster than xargs (1.7879x)      forkrun is 87% faster than parallel (1.8701x)
cksum -a sm3    2.5808076571    4.5859107501    4.2774210021    forkrun is 77% faster than xargs (1.7769x)      forkrun is 65% faster than parallel (1.6573x)

OVERALL         11.208696556    19.960088514    20.828762659    forkrun is 78% faster than xargs (1.7807x)      forkrun is 85% faster than parallel (1.8582x)



||--------------------------------------------------------NUM_CHECKSUMS=100000--------------------------------------------------------------------------------|| 

(algorithm)       (forkrun)        (xargs)        (parallel)    (relative performance vs xargs)                         (relative performance vs parallel)                
------------    ------------    ------------    ------------    --------------------------------                        --------------------------------                  
sha1sum         0.8230874306    1.2559810074    3.9540721269    forkrun is 52% faster than xargs (1.5259x)      forkrun is 380% faster than parallel (4.8039x)
sha256sum       1.6484554502    2.6550891789    4.0367873319    forkrun is 61% faster than xargs (1.6106x)      forkrun is 144% faster than parallel (2.4488x)
sha512sum       1.1750274711    1.8904443909    4.0000258502    forkrun is 60% faster than xargs (1.6088x)      forkrun is 240% faster than parallel (3.4041x)
sha224sum       1.6352138492    2.6546941293    4.0488493457    forkrun is 62% faster than xargs (1.6234x)      forkrun is 147% faster than parallel (2.4760x)
sha384sum       1.1548144916    1.8433252592    4.0058443152    forkrun is 59% faster than xargs (1.5962x)      forkrun is 246% faster than parallel (3.4688x)
md5sum          1.0083714716    1.6938738980    4.0088253269    forkrun is 67% faster than xargs (1.6798x)      forkrun is 297% faster than parallel (3.9755x)
sum -s          0.1964396966    0.2954914663    3.9373926711    forkrun is 50% faster than xargs (1.5042x)      forkrun is 1904% faster than parallel (20.0437x)
sum -r          1.0079121610    1.7266721227    4.0079479643    forkrun is 71% faster than xargs (1.7131x)      forkrun is 297% faster than parallel (3.9764x)
cksum           0.1773627671    0.2471011836    3.9402946387    forkrun is 39% faster than xargs (1.3931x)      forkrun is 2121% faster than parallel (22.2160x)
b2sum           1.0068455244    1.6141367308    3.9931291681    forkrun is 60% faster than xargs (1.6031x)      forkrun is 296% faster than parallel (3.9659x)
cksum -a sm3    2.9793014210    4.9038082163    4.2788775805    forkrun is 64% faster than xargs (1.6459x)      forkrun is 43% faster than parallel (1.4362x)

OVERALL         12.812831734    21.733326303    44.569658211    forkrun is 69% faster than xargs (1.6962x)      forkrun is 247% faster than parallel (3.4785x)



||--------------------------------------------------------NUM_CHECKSUMS=521911--------------------------------------------------------------------------------|| 

(algorithm)       (forkrun)        (xargs)        (parallel)    (relative performance vs xargs)                         (relative performance vs parallel)                
------------    ------------    ------------    ------------    --------------------------------                        --------------------------------                  
sha1sum         1.6286943159    2.0199643854    20.075420332    forkrun is 24% faster than xargs (1.2402x)      forkrun is 1132% faster than parallel (12.3260x)
sha256sum       2.8644944094    3.5045886992    20.311441071    forkrun is 22% faster than xargs (1.2234x)      forkrun is 609% faster than parallel (7.0907x)
sha512sum       2.2340511511    2.6935622735    20.209039190    forkrun is 20% faster than xargs (1.2056x)      forkrun is 804% faster than parallel (9.0459x)
sha224sum       2.8613993569    3.4881405630    20.313363307    forkrun is 21% faster than xargs (1.2190x)      forkrun is 609% faster than parallel (7.0991x)
sha384sum       2.1859892692    2.6624580626    20.175458431    forkrun is 21% faster than xargs (1.2179x)      forkrun is 822% faster than parallel (9.2294x)
md5sum          1.727604421     2.3530172968    20.110481363    forkrun is 36% faster than xargs (1.3620x)      forkrun is 1064% faster than parallel (11.6406x)
sum -s          0.7482615006    1.1313569398    19.882553867    forkrun is 51% faster than xargs (1.5119x)      forkrun is 2557% faster than parallel (26.5716x)
sum -r          1.6692639257    2.3338452146    20.144961839    forkrun is 39% faster than xargs (1.3981x)      forkrun is 1106% faster than parallel (12.0681x)
cksum           0.7278956696    1.1016801017    19.863852705    forkrun is 51% faster than xargs (1.5135x)      forkrun is 2628% faster than parallel (27.2894x)
b2sum           1.9601611987    2.4058454718    20.198290951    forkrun is 22% faster than xargs (1.2273x)      forkrun is 930% faster than parallel (10.3044x)
cksum -a sm3    4.9776278830    6.2101821971    20.868720708    forkrun is 24% faster than xargs (1.2476x)      forkrun is 319% faster than parallel (4.1925x)

OVERALL         23.585443101    30.379229874    223.42316627    forkrun is 28% faster than xargs (1.2880x)      forkrun is 847% faster than parallel (9.4729x)
EOF
