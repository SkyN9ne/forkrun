#!/bin/bash

source <(curl https://raw.githubusercontent.com/jkool702/forkrun/main/forkrun.bash)

mkdir -p /mnt/ramdisk
cat /proc/mounts | grep -F '/mnt/ramdisk' || mount -t tmpfs tmpfs /mnt/ramdisk

rsync -a /usr /mnt/ramdisk

mapfile -t A0 < <(find /mnt/ramdisk -type f | head -n $(( $(nproc) * 1024 )))
mapfile -t A1 < <(printf '%s\n' "${A0[@]}" | head -n $(( $(nproc) * 128 )))
mapfile -t A2 < <(printf '%s\n' "${A1[@]}" | head -n  $(( $(nproc) + 2 )))
mapfile -t A3 < <(printf '%s\n' "${A2[@]}" | head -n  $(( $(nproc) - 2 )))

nMax=8
set -m

[[ -f ./forkrun.unit-tests.log ]] && cat ./forkrun.unit-tests.log >> ./forkrun.unit-tests.log.old && rm -f ./forkrun.unit-tests.log

for nn in A3 A2 A1 A0; do

#source <(echo 'mapfile -t C < <(printf '"'"'%s\n'"'"' "${'"${nn}"'[@]}")')
declare -n C="$nn"

echo "BEGINNING TEST CASE FOR STDIN LENGTH = ${#C[@]}" | tee ./forkrun.unit-tests.log.


{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -k -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -n -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -k -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -l 1 -n -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -k -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -n -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -k -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -- sha1sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -- sha1sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -- sha256sum | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -- sha256sum | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -- printf '%s\n' | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -- printf '"'"'%s\n'"'"' | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i -- sha1sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i -- sha1sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i -- sha256sum {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i -- sha256sum {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 
{ { curLength=$(printf '%s\n' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i -- printf '%s\n' {} | wc -l); correctLength=${#C[@]}; (( ${curLength} == ${correctLength} )) && echo -n "PASS: " >&3 || echo -n "FAIL (EXPECTED ${correctLength} -- GOT ${curLength}): " >&3; echo 'printf '"'"'%s\n'"'"' "${C[@]}" | forkrun 2>/dev/null -j 27 -l 1 -n -t /tmp -d 3 -i -- printf '"'"'%s\n'"'"' {} | wc -l' >&3; } 3>&1 |  tee -a forkrun.unit-tests.log; } &
sleep 0.01s
(( $(jobs -rp | wc -l) >= ${nMax} )) && wait -n 


done
