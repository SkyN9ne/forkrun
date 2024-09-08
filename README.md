# FORKRUN

`forkrun` is an *extremely* fast pure-`bash` function that leverages `bash` shell's `coprocs` to efficiently run several commands simultaneously in `parallel` (i.e., it's a "loop parallelizer"). 

`forkrun` is used in much the same way that `xargs` or `parallel` are, but is faster (see the `hyperfine_benchmark/` subdirectory for the benchmarks) while still being fully-featured and only requires having a reasonably  recent `bash` version (v4.0+) to run<sup>1</sup>. `forkrun`:
* offers more features than `xargs` and is mildly faster than it's fastest invocation (`forkrun` without any flags is functionally equivalent to `xargs -P $*(nproc) -d $'\n'`),
* is considerably faster than `parallel` (over an order of magnitude faster in some cases) while still supporting most of the particularly useful "core" `parallel` features,
* can easily and efficiently be adapted to parallelize complex tasks without penalty by using shell functions (unlike `xargs` and `parallel`, `forkrun` doesn't need to call a new instance of `/bin/bash -c` on every `loop` iteration when the shell function is run).

<sup>1: `bash v5.1+` is preffered and much better tested. A few basic filesystem operations (`rm`, `mkdir`) must also be available. `fallocate` and `inotifywait` aren't required; but, if present will be used to lower runtime resource usage. `bash-completion` is required to enable automatic-completion (on `<TAB>` press) when typing the `forkrun` cmdline.</sup>

**Current Version**: `forkrun v1.4.0`

**Previous Version**: `forkrun v1.3.0`

# CHANGELOG

**forkrun v1.4**:  3 new features have been added:

1. `forkrun` can now dynamically determine how many `coprocs` to spawn based on runtime conditions (specifically: the CPU usage and whether or not `coprocs` are waiting in a read queue to read data from `stdin`). To use this functionality, pass the `;-j;` flag a negative number (just passing `-j -` works too). See the help (run `forkrun --help` or `forkrun --help=all`) for additional info.

2. `forkrun` can now read it's input from a file descriptor other than `stdin` using the `-u` flag (which is standard in `bash`'s `read` and `mapfile` commands).

3. MINOR API CHANGE: the previous `-u` flag, which prevents escaping the commands given on `forkrun`'s command-line, has been changed to use `-U` or `--UNESCAPE` (i.e., it's now UPPERCASE instead of lowercase).
4. on 64-bit x86_64 architecture and platforms, `forkrun` will use a custom `bash` loadable built-in to call `lseek`, greatly improving the efficiency of reading data from `stdin` as `forkrun` runs. `forkrun`'s "no-load" speed (i.e., `stdin` is all `\n` new-lines and they are being passed to a `:` call) now exceeds 4 million+ lines per second on the `Origin`'s benchmarking system, highlighting how efficient `forkrun`'s parallelization framework is. Using `lseek` also removes `dd` from the "required dependency" list, even when using `NULL-` delimited input.

**forkrun v1.3**: `forkrun {-z|-0|--null}` has been fixed and now works 100% reliably with `NULL`-delimited input! However, [only] when using `NULL`-delimited input `dd` is now a required dependency.

**forkrun v1.2**: `forkrun` now supports `bash`'s auto-completion. Pressing `<TAB>` while typing out the `forkrun` commandline will auto-complete (when possible) `forkrun`'s  options, command names, and command options. If no unique auto-complete result is available, pressing `<TAB>` a second time will bring up a list of possibilities. The code required for this functionality is loaded (via the `_forkrun_complete` function) and registered (via the `complete` built-in) when `forkrun.bash` is `source`d.

NOTE: `forkrun` uses mildly "fuzzy" option matching, so to make the automatic completion feature actually useful, only the single most reasonable completion is shown for any given `forkrun` option(s). e.g., the completion for typing `--pip` will only show `--pipe`, but if you continue typing `--pipe-r` the completion will change to `--pipe-read`, since `--pipe` and `--pipe-read` are both `alias`'es for the same option (`-p`).

**forkrun v1.1**: 2 new flags (`-b <bytes>` and `-B <bytes>`) that cause `forkrun` to `split` up `stdin` into blocks of `<bytes>` bytes. `-B` will wait and accululate blocks of exactly `<bytes>` bytes, `-b` will not. The `-I` flag has been expanded so that if `-k` (or `-n`) is also passed then a second sub-stitution is made, swapping `{IND}` for the batch ordering index (the same thing that `-n` outputs at the start of each block) (`{ID}` will still be swapped for `coproc` ID). A handful of optimizations and bug-fixes have also been implemented (notably with how the `coproc` source code is dynamically generated). Lastly. the `forkrun` repo had some changes to how it is organized.

NOTE: for the `-b` and `-B` flags to have the sort of efficiency and speed that `forkrun` typically has, you need to have GNU's `dd` available. If you don't, `forkrun` will try to use `head -c` (which is *much* slower), and if that's unavailable as well it'll use the `read` built-in with either `-n` or `-N` (which is *much* slower still...You *really* want to use GNU `dd` here). Also, when using these flags the `-S` flag is automatically selected, meaning the data is passed to the function by being parallelized via its `stdin`. This is to avoid mangling binary data passed to `stdin`. This can be over-ruled by passing the `+S` flag, but all `NULL`'s in `stdin` will be dropped.

***

# Usage:

`forkrun` is invoked in largely the same way as `xargs`: on the command-line, pass `forkrun` options, then the function / script / binary data or file that you are parallelizing, then any initial `constant` arguments (in that order). The arguments to parallelize running are passed to `forkrun` on `stdin`. A typical `forkrun` invocation looks something like this:

```bash
printf '%s\n' "${inArgs[@]}" | forkrun [flags] [--] <parFunc> ["${args0[@]}"]

forkrun [flags] [--] <parFunc> ["${args0[@]}"] <inArgs
```

`forkrun` strives to automatically choose reasonable and near-optimal values for flags, so in most usage scenarios no flags will need to be set to attain maximum performance and speed.

NOTE: you'll need to `source` the `forkrun` before you can start using it

```bash
source /path/to/forkrun.bash
```

Alternately, if you don't have `forkrun.bash` saved locally but do have Internet access (or want to ensure you are using the latest version), you can run
    
```bash
source <(curl https://raw.githubusercontent.com/jkool702/forkrun/main/forkrun.bash)
```

Or, for those (understandably) concerned with directly sourcing unseen code from the Internet, you could use:

```bash
source <(echo 'shopt -s extglob'; ( cd /proc/self/fd; decfun='forkrun forkrun_displayHelp '; type -p cat &>/dev/null || decfun+='cat '; type -p mktemp &>/dev/null || decfun+='mktemp '; shopt -s extglob; curl="$(type -p curl)"; bash="$(type -p bash)"; PATH=''; { $curl https://raw.githubusercontent.com/jkool702/forkrun/main/forkrun.bash; echo 'declare -f '"$decfun"; } | $bash -r ) )
```

This monster of a one-liner will `source` the `forkrun` code in an extremely restricted shell that really couldn't do much else, then `declare -f` the required `forkrun` functions and finally the main shell `source`s those. This drops any non-`forkrun`-related code and ensures that nothing is actually run until the `forkrun` function is called, giving you a chance to review the code via `declare -f` (should you wish). This offers some protection against a bad actor maliciously changing the code (without your nor my knowledge) through some attack, especially if you're using HTTP instead of HTTPS / QUIC that's using TLS v1.2-v1.3 + SSL.

**PARALLELIZING Functions**: one extremely powerful feature of `forkrun` is that it can parallelize arbitrary complex tasks very efficiently by wrapping them in a function. This is done by doing something like the following:

```bash
myfun() {
    mapfile -t A < <(some_task "$@")
    some_other_task "${A[@]}"
    # ...
}

forkrun myfun <inputs
```

`forkrun` particularly excels at doing this since, unlike other loop parallelizers that have to spin up a whole new `bash` shell for every function invocation, `forkrun` simply calls this function directly. For simple functions (e.g., `myfun() { :; }`), simply running `myfun` from an already-running `bash` shell is ~200x faster and more efficient than running: 

```bash
export -f myfun; bash -c 'myfun'
```

The overhead from 10,000 calls is ~55 seconds using `bash -c` vs ~1/4 or 0.25 seconds / 250ms+ with direct calling).

***

**HELP**: the `forkrun.bash` script, when `source`d, will `source` a helper function (`forkrun_displayHelp`) to display help. This is activated by calling one of the following:

```command
--usage              :  display brief usage info
-? | -h | --help     :  dispay standard help (includes brief descriptions + short names for flags)
--help=s[hort]       :  more detailed varient of '--usage'
--help=f[lags]       :  display detailed info about flags (longer descriptions, short + long names)
--help=a[ll]         :  display all help (includes detailed descriptions for flags)
```

NOTE: text inside of the brackets `[...]` is optional.

NOTE: `forkrun -?` may not work unless you escape the `?`. i.e., `forkrun -\?` or `forkrun '-?'`

**Speed**: In the Original testing benchmarking utilities, `forkrun` was, on average (for problems where the efficiency of the parallelization framework actually makes a difference) ~20% faster to twice as fast versus `xargs -P $(nproc);` and ~2x upto ~8x as fast versus `parallel -m`. To be clear: these are the "fast" invocations of `xargs` and `parallel`. If you were to compare the "1 line at a time" version of all 3 (`forkrun -l1`, `xargs -P $(nproc) -L 1`, `parallel -j $(nprooc)`), `forkrun` is 7-10x as fast as `xargs` and 20-30x as fast as `parallel`.

***
    
# How It Works 

**Bash COPROCS**: `forkrun` parallelizes loops by running multiple inputs through a script / function in `parallel` using `bash` shells `coprocs`. `forkrun` is fundamentally different than most of the existing loop parallelization-based coding in the sense that individual function evaluations (`eval`) aren't being forked. Rather, initially a number of persistent `bash` shells `coprocs` are forked, and then inputs (passed through `stdin`) are distributed to these `coprocs` without any additional forking (or reopening pipes / `fd`'s, or ...). In other words, you **Fork** [`coprocs`], then you **Run**. This, combined with the (almost) exclusive use of `bash` built-in's as well as being *heavily* optimized, is what makes `forkrun` so fast.  

Coproc workers read data (via `mapfile`) using a shared file descriptor, keeping them all "in sync" and allowing Worker's to read data "on demand" without any `buffer`'s. This necessitates only allowing 1 Worker to read data at a time, but has the benefit of avoiding the CPU overhead of the potentially bottle-necking (especially on high-core count systems) from, and the need to `buffer` inputs due to having a separate process explicitly distribute `stdin` to the Worker's `coprocs`. Typically a Helper `coproc` saves `stdin` into a `tmpfs` temp file (under `/dev/shm`) and Worker's reading from the `tmpfile` (avoiding the "read 1 byte at a time from pipes" issue); but, depending on the flags passed to `forkrun`, the Worker's can also read data directly from the `stdin pipe`.

Compared to the traditional approach, `forkrun`'s approach allows for much better usage of multiple CPU cores in `parallel`, since nearly every task can be run in `parallel`. The traditional "`fork`ing every function call" method, on the other hand, can be implemented in such a way that it takes slightly fewer total CPU cycles, but that comes at the cost of having most of the CPU cores waiting while the `main` thread is setting up / cleaning up after the forked function call. To be clear here, I am referring to forking in a lower-level language such as C ... forking in `bash` is horribly slow and inefficient, and any pure-`bash` loop parallelizer that forks every function call will take orders of magnitude more time and CPU cycles to run.

To give a real-life data point: on the original Benchmarks testing rig that has a 14-Core / 28-Thread Intel Core i9-7940X CPU, `perf` consistently tells me that for sufficiently large problems, `forkrun` is  (averaged over its entire runtime) fully utilizing between 19-20 cores. Considering that the machine only has 14 "real" cores and that 28 threads running on 14 hyperthreaded cores will never be as capable as 28 threads running on 28 "real" non-hyperthreaded cores, doing (on average) nearly 20 cores worth of work is about as good as it gets.

***

**AUTOMATIC BATCH SIZE ADJUSTMENT**: By default, `forkrun` will automatically dynamically adjust how many lines are passed to the function each time it's called (batch size). The batch size starts at 1, and is dynamically adjusted upwards (but never downwards) up to a maximum of 512 lines per batch (which is typically near-optimal in the original benchmarking trial-and-error testing). The logic used here involves:

1. Calculating the average bytes / line by looking at the number of lines read and the number of bytes read (from `/proc/self/fdinfo/$fd`)
2. Estimating the number of remaining lines left to read by getting the difference in the number of bytes read / written and dividing by the average bytes / line
3. Dividing the estimated number of remaining lines by the number of Worker's `coprocs`

NOTE: this is a "maximum lines per batch" (implemented via `mapfile -n ${nLines}`)... If `stdin` is arriving slowly then fewer than this many lines will be used. What this serves to accomplish is to prevent a couple of `coproc` workers from claiming all the lines of input while the rest sit idle if the total number of lines is less than `512 * (# worker coprocs)`

To overrule this logic and set a static batch size use the `-l` flag. Alternatively, use the `-L` flag to keep the automatic batch size logic enabled but to change the initial and maximum number of lines per batch.

***

**IPC**: `forkrun` distributes `stdin` to the worker `coprocs` by first saving them to a `tmpfile` (by default on a `tmpfs` in a directory under `/dev/shm`; customizable with the `-t` flag) using a `fork`ed `coproc`. The worker `coprocs` then read data from this file into an array (using `mapfile`) using a shared read-only file descriptor and an exclusive read lock. 

***

**NO FUNCTION MODE**: `forkrun` supports an additional mode of operation where `parFunc` and `initialArgs` aren't given as function inputs, but instead are integrated into each line of `args`. In this mode, each line passed on `stdin` will be run as-is (by saving groups of 512 lines to `/tmp` files and then sourcing them). This allows you to easily run multiple different functions / scripts / binaries in `parallel` and still utilize `forkrun`'s very quick and efficient parallelization method(s). To activate this mode, use the flag `-N` and do not provide `parFunc` or `initialArgs`. This is implemented via `source <(printf '%s\n' "${args[@]}")`

***

# DEPENDENCIES

`forkrun` strives to rely on as few external dependencies as possible. It is *almost* pure-`bash`, though does have a handful of [optional] external dependencies:

***

**REQUIRED DEPENDENCIES**

`bash v4+` :             This is when `coprocs` were added. 

NOTE: `forkrun` will be much faster on `bash v5.1+`, since it healivy relies on arrays and the `mapfile` command which got a major overhaul in `bash v5.1`. The vast majority of testing has been done on `bash v5.2` so while `bash v4-5.0` *should* work it's not well tested.

`rm` and `mkdir`:     For some basic filesystem operations. I couldn't figure out how to re-implement these in pure `bash`. Either the GNU or the busybox versions of these will both work.

`dd`:                 Only when using `NULL`-delimited input (flag `-z` or `-0` or `--null`), GNU's `dd` is obviously required. It's used to quickly `seek` to a specific byte location in the file caching `stdin` and check if the specified byte is a `NULL` to detect and correct for partial line reads.

***

**Optional Dependencies**

`bash v5.1+`:           For improved speed due to overhauled handling of arrays.

`mktemp` and `cat`:  The code will provide pure-`bash` replacements for these if they aren't available, but if external binaries for these are present they will be used

`inotifywait`:       If available, this is used to monitor the `tmpfile` where `stdin` is being saved before being read by the `coprocs`. This enables the `coprocs` to efficiently `wait` for input if `stdin` is arriving too slowly (e.g., `ping 1.1.1.1 | forkrun <...>`)

`fallocate`:         If available, this is used to deallocate already-processed data from the beginning of the `tmpfile` holding `stdin`. This enables `forkrun` to be used in long-running processes that consistently output data for days / weeks / months / ... Without `fallocate`, this `tmpfile` will continually grow and will not be removed until `forkrun` `exit`s 

`dd` (GNU)  -Or-  `head` (`GNU|busybox`): When `split`ting up `stdin` by byte count (due to either the `-b` or the `-B` flag being used), if either of these is available it will be used to read `stdin` instead of the built-in `read -N`. Note that one of these is required to `split` + process binary data without mangling it - otherwise `bash` will drop any `NULL`'s. If both are available `dd` is preferred.

`bash-completion`:   Required for bash automatic-completion (on `<TAB>` press) to work as you are typing the `forkrun` commandline. This is strictly a "quality of life" feature to make typing the `nforkrun` commandline easier -- it has zero effect on `forkrun`'s execution after it has been called.

***

# Why To Use FORKRUN

There are 2 other common programs for parallelizing loops in the (`bash`) shell: `xargs` and `parallel`. I believe `forkrun` offers more than either of these programs can offer:

***

**Compared To PARALLEL**

* `forkrun` is considerably faster. In terms of "wall clock time" in the original benchmarking tests where 11 different checksums of ~500,000 small files totaling ~19GB saved on a `ramdisk` (see the `hyperfine_speedtest/` sub-directory for details):
  * `forkrun` was on average 8x faster than `parallel -m` for very large file counts. For all batch sizes tested `forkrun` was at least twice as fast as `parallel`
  * In the particuarly lightweight checksums (`sum -s`, `cksum`) `forkrun` was ~18x faster than `parallel -m`.
  * If comparing in "1 line at a time mode", `forkrun` is more like 20-30x faster.
  * In terms of "CPU" time `forkrun` also tended to use less CPU cycles than `parallel`, though the difference here is smaller (`forkrun` is very good at fully utilizing all CPU cores, but doesn't magically make running whatever is being parallelized take fewer CPU cycles than running it sequentially would've taken).
* `forkrun` has fewer dependencies. As long as your system has a recent-ish version of `bash` (which is pre-installed on basically almost every non-embedded Linux / UNIX based Operating Systems) it can run `forkrun`. `parallel`, on the other hand, is not typically installed by default.

***

**Compared To XARGS**

* Better set of available options. All of the `xargs` options (excluding those intended for running code interactively) have been implemented in `forkrun`. Additionally, a handful of additional (and rather useful) options have also been implemented. This includes:
  * ordering the output the same as the input (making it much easier to use `forkrun` as a filter)
  * passing `stdin` to the workers via the `stdin` using Worker's (`func <<<"${args[@]}"` instead of `func "${args[@]}"`)
  * a "no function mode" that allows you to embed the code to run into `"${args[@]}"` and run arbitrary code that differs from online to line in `parallel`
  * The ability to unescape (via the `-u` flag) the input and have the commands run by `forkrun` interpreting things such as `redirect`s and `fork`s. (this *might* be possible in `xargs` by wrapping everything in a `bash -c` call, but that's unnecessary here).
  * Better / easier usage of the `-i` flag to replace `{}` with the lines from `stdin`. No need to wrap everything in a `bash -c '...' _` call, and the `{}` can be used multiple times.

* Because `forkrun` runs directly in the shell, other shell functions can be used as the `parFunc` being parallelized (this *might* be possible in `xargs` by `export`ing the function first, but this isn't needed with `forkrun`)

* Because `forkrun` is faster in problems where parallelization speed matters (in problems where total run-time is over at least 50ms+ or so).

Benchmarking `forkrun` is twice as fast in medium-size problems (10,000 - 100,000 inputs) and slightly faster (10-20%) in large-size problems (>500,000 inputs).

***

### Supported Options / Flags 

`forkrun` supports many of the same flags as `xargs` (excluding options intended for interactive use), plus several additional options that are present in `parallel` but not `xargs`. A quick summary will be provided here - for more info refer to the comment block at the top of the `forkrun` function, or `source forkrun 
` and then run `forkrun --help[={flags,all}]`.

GENERAL NOTES:
    1.  Flags must be given separately (e.g., use `-k -v` instead of `-kv`) 
    2.  Flags must be given before the name of the function being parallelized (`parFunc`) -- any flags given after the function name will be assumed to be initial arguments for the function, not `forkrun` options.
    3.  There are also `long`  versions of the flags (e.g., `--insert` is the same as `-i`). Run `forkrun --help=all` for a full list of long options / flags.

The following flags are supported:

**FLAGS WITH ARGUMENTS**

```command
   (-j|-p) <#>  : num worker coprocs. set number of worker coprocs. Default is $(nproc).
    -l <#>      : num lines per function call (batch size). set static number of lines to pass to the function on each function call. Disables automatic dynamic batch size adjustment. if -l=1 then the "read from a pipe" mode (-p) flag is automatically activated (unless flag `+p` is also given). Default is to use the automatic batch size adjustment.
    -L <#[,#]>  : set initial (<#>) or initial+maximum (<#,#>) lines per batch while keeping the automatic batch size adjustment enabled. Default is '1,512'
    -t <path>   : set tmp directory. set the directory where the temp files containing lines from stdin will be kept. These files will be saved inside a new mktemp-generated directory created under the directory specified here. Default is '/dev/shm', or (if unavailable) '/tmp'
 -d <delimiter> : set the delimiter to something other than a newline (default) or NULL ((-z|-0) flag). must be a single character.
```

**FLAGS WITHOUT ARGUMENTS**: for each of these passing `-<FLAG>` enables the feasture, and passing `+<FLAG>` disables the feature. Unless otherwise noted, all features are, by default, disabled. If a given flag is passed multiple times both enabling `-<FLAG>` and disabling `+<FLAG>` some option, the last one passed is used.

```
SYNTAX NOTE: for each of these passing `-<FLAG>` enables the feasture, and passing `+<FLAG>` disables the feature. Unless otherwise noted, all features are, by default, disabled. If a given flag is passed multiple times both enabling `-<FLAG>` and disabling `+<FLAG>` some option, the last one passed is used.

    -i          : insert {}. replace `{}` with the inputs passed on stdin (instead of placing them at the end)
    -I          : insert {id}. replace `{id}` with an index (0, 1, ...) describing which coproc the process ran on. 
    -k          : ordered output. retain input order in output. The 1st output will correspond to the 1st input, 2nd output to 2nd input, etc. 
    -n          : add ordering info to output. pre-pend each output group with an index describing its input order, demoted via `$'\n'\n$'\034'$INDEX$'\035'$'\n'`. This requires and will automatically enable the `-k` output ordering flag.
    (-0|-z)     : NULL-seperated stdin. stdin is NULL-separated, not newline separated. WARNING: this flag (by necessity) disables a check that prevents lines from occasionally being split into two separate lines, which can happen if `parFunc` evaluates very quickly. In general a delimiter other than NULL is recommended, especially when `parFunc` evaluates very fast and/or there are many items (passed on stdin) to evaluate.
    -s          : run in subshell. run each evaluation of `parFunc` in a subshell. This adds some overhead but ensures that running `parFunc` does not alter the coproc's environment and affect future evaluations of `parFunc`.
    -S          : pass via function's stdin. pass stdin to the function being parallelized via stdin ( $parFunc < /tmpdir/fileWithLinesFromStdin ) instead of via function inputs  ( $parFunc $(</tmpdir/fileWithLinesFromStdin) )
    -p          : pipe read. dont use a tmpfile and have coprocs read (via shared file descriptor) directly from stdin. Enabled by default only when `-l 1` is passed.
    -D          : delete tmpdir. Remove the tmp dir used by `forkrun` when `forkrun` exits. NOTE: the `-D` flag is enabled by default...disable with flag `+D`.
    -N          : enable no func mode. Only has an effect when `parFunc` and `initialArgs` are not given. If `-N` is not passed and `parFunc` and `initialArgs` are missing, `forkrun` will silently set `parFunc` to `printf '%s\n'`, which will basically just copy stdin to stdout.
    -u          : unescape redirects/pipes/forks/logical operators. Typically `parFunc` and `initialArgs` are run through `printf '%q'` making things like `<` , `<<` , `<<<` , `>` , `>>` , `|` , `&&` , and `||` appear as literal characters. This flag skips the `printf '%q'` call, meaning that these operators can be used to allow for piping, redirection, forking, logical comparison, etc. to occur *inside the coproc*. 
    --          : end of forkrun options indicator. indicate that all remaining arguments are for the function being parallelized and are not forkrun inputs. This allows using a `parFunc` that begins with a `-`. NOTE: there is no `+<FLAG>` equivalent for `--`.
    -v          : increase verbosity level by 1. This can be passed up to 4 times for progressively more verbose output. +v decreases the verbosity level by 1.
    (-h|-?)     : display help text. use `--help=f[lags]` or `--help=a[ll]` for more details about flags that `forkrun` supports. NOTE: you must escape the `?` otherwise the shell can interpret it before passing it to forkrun.
```
