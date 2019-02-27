# SyLVer Simulink Driver v. 1.0

**System Level Formal Verifier (SyLVer) Simulink Driver v. 1.0** is distributed under **MIT License**. 
This software is used for [SyLVer and SyLVaaS applications](http://mclab.di.uniroma1.it/site/index.php/software/44-sylvaas).

Main elements of SyLVer Simulink Driver are the following (more details on files in section [Source Code Structure](#markdown-header-source-code-structure)):

* **Disturbances dictionary** file (`dictionary.txt`).
* Subfolder containing all **simulation campaigns** (`simulation-campaigns/`).
* **MATLAB scripts** `*.m` containing the core code of driver.
* **Bash program `run.sh`** which is the entry point for running simulation campaigns.
* Python program to **post-process execution times log file** (`simulator_driver_split_times_log_in_separate_files.py`)
* **License file** of MIT License (`LICENSE.txt`).

Before enjoing simulations, please read sections [Initial Configuration](#markdown-header-initial-configuration), [Run a Simulation Campaign](#markdown-header-run-a-simulation-campaign), and [Notes on Simulink Driver](#markdown-header-notes-on-simulink-driver).

## Initial Configuration

Before running any simulation campaign, the driver must be instiantiated for the System Under Verification (SUV) and disturbances at hand.

The operations to perform are:

1. [Place SUV file inside driver folder](#markdown-header-1-place-suv-file-inside-driver-folder)
2. [Change init configuration file](#markdown-header-2-change-init-configuration-file)
3. [Change disturbance dictionary file](#markdown-header-3-change-disturbance-dictionary-file)
4. [Change file for getting SUV parameters values related to disturbances](#markdown-header-4-change-file-for-getting-suv-parameters-values-related-to-disturbances)
5. [Change file for setting SUV parameters values related to disturbances](#markdown-header-5-change-file-for-setting-suv-parameters-values-related-to-disturbances)

### 1. Place SUV file inside driver folder
Copy inside this folder the **SUV Simulink file equipped with monitor** for checking desired properties. If SUV is file is `system.mdl` in folder `$PATH_TO_SIMULINK_SUV`, then from inside driver folder execute the command:

```
cp $PATH_TO_SIMULINK_SUV/system.mdl .
```

### 2. Change init configuration file

At the end of file

```
./simulator_driver_init.m
```

there are rows

```
% CHANGE HERE BELOW:
SUV_and_monitor = 'WRITE_SYSTEM_NAME_HERE';
```

Substitute `WRITE_SYSTEM_NAME_HERE` with the name of the SUV at hand. E.g., if the SUV is  `system.mdl` then these lines will look like:

```
% CHANGE HERE BELOW:
SUV_and_monitor = 'system';
```

### 3. Change disturbance dictionary file
The dictionary is where you associate disturbance numbers to the corresponding MATLAB disturbance. Each disturbance can modify more MATLAB parameters in the same time. The disturbances file is called `dictionary.txt`.

An example of content of file `dictionary.txt` is

```
{0} {NOP} {None} {None};
{1} {Remove Disturbance, d:1} {YawAddError_dist_ampl} {0} {YawAddError_dist_freq} {100};
{2} {Inject Disturbance, d:1} {YawAddError_dist_ampl} {0.0001} {YawAddError_dist_freq} {100};
```

The dictionary is composed by many rows, each one indicating one disturbance. The general syntax of a row (as a regualar expression) is

```
{NUMBER:n} {STRING:description} [{STRING:label} {STRING:value}]+;
```

The meaning of such regular expression is as follows. 

* This disturbance is known as number `n` in the simulation campaign.
* Disturbance description is `description` (this string will not be used by the driver).
* A non-empty set A of assignments (label, value) to SUV parameters is associated to this disturbance; for each assignment a in A, `a.label` is the label used by the MATLAB driver to refer to this disturbance and `a.value` is the value (as a string) that MATLAB will use to set the corresponding SUV parameter.

There is one special row (the first in the example above)

```
{0} {NOP} {None} {None};
```

which is the no-operation disturbance. In other words, when the campaign contains `I0` then the MATLAB driver will perform no disturbance injection.

Note that, in the dictionary, only (label, value) pairs are supplied. The association between each label and the corresponding MATLAB parameter to be modified has to be specified in other files (see sections 4 and 5 in what follows).


### 4. Change file for getting SUV parameters values related to disturbances
At the end of file

```
./simulator_driver_get_params.m
```

define MATLAB structure `currinput` containing mapping between disturbances labels and corresponding Simulink parameters.

As an example, with the dictionary in previous section, `currinput` will be defined as follows

```
currinput = struct('YawAddError_dist_ampl', get_param('apollo_dap/Yaw Disturber', 'dist_ampl'),...
                   'YawAddError_dist_freq', get_param('apollo_dap/Yaw Disturber', 'dist_freq'),...
```

Note that in `currinput` there is one field for each different label appearing in `disturbances.txt`. If the same label appears more than once in `disturbances.txt`, it is only needed to create one field for that label in `currinput`.

### 5. Change file for setting SUV parameters values related to disturbances
File

```
./simulator_driver_set_params.m
```

is the program invoked at the beginning of each *run* of simulation campaigns, used to set Simulink parameters from `currinput` values (see section Notes on Simulink Driver for more details on invokation of this program).

Continuing from previous example, we can write:

```
set_param('apollo_dap/Yaw Disturber', 'dist_ampl', currinput.YawAddError_dist_ampl)
set_param('apollo_dap/Yaw Disturber', 'dist_freq', currinput.YawAddError_dist_freq)
```

In this way, when the simulation campaign contains command `I1` then the driver will set `currinput.YawAddError_dist_ampl` to `0` and `currinput.YawAddError_dist_freq` to `100` (thanks to second row of dictionary above). 
Consequently, when `./simulator_driver_set_params.m` is invoked before the next run command, parameters `'dist_ampl'` and `'dist_freq'` of `'apollo_dap/Yaw Disturber'` will be set to `0` and `100`, respectively.

Be aware that on one hand the **dictionary** contains, for each disturbance *i*, `currinput` field names concerning *i* (labels) and values to be set when executing simulation campaign command `Ii`. In the example above, field names are `YawAddError_dist_ampl` and `YawAddError_dist_freq`.
On the other hand, files **`simulator_driver_get_params.m`** and **`simulator_driver_set_params.m`** contain the relation between `currinput` fields and SUV blocks to be modified. 


## Run a Simulation Campaign

Run

	$ bash run.sh -M /usr/local/matlab -T 0.5 -k 10 -s 1 -S 64

to run simulation with MATLAB in path `/usr/local/matlab`, of campaign 1
(out of 64) with sampling time equal to 0.5
and with printing of what is left
in terms of coverage each 10 simulation
steps inside file 'coverage.txt'.
Output is normally redirected to file 'output.txt'
but it can be changed with -o.

Script `run.sh` creates files:

* `output.txt` with MATLAB output;
* `coverage.txt` for information on simulation campaign coverage;
* `times_log.txt` for information on execution time of each command in the simulation campaign. This file has information on all commands. In order to get one file for each command with specific information on running times for that commmand, use auxiliary Python script running

```
$ python simulator_driver_split_times_log_in_separate_files.py
```

Normally, the driver is run without signal logging capabilities. This means that parameter `SignalLogging` is initially set to `off` for the whole SUV. For debugging reasons, or when an error is found and you want to visualise signals in the error trace, just enable signal logging with `run.sh -l` option.

Run help to know what is customizable:

	$ bash run.sh -M /usr/local/matlab -h

    Usage: run.sh 	[-h] 
                    [-M MATLAB-path-to-executable] 
                    [-T simulator-sampling-time] 
                    [-k print-coverage-each-k-traces] 
                    [-s simulation-campaign-index] 
                    [-S simulation-campaigns-number] 
                    [-o logging-file]
                    [-l] (* Enables signal logging for debug. Slows down speed. *)
                    [-d debugging-level]

    MATLAB path to executable (-M arg). . . . . . .: /usr/local/matlab
    Simulator sampling time (-T arg). . . . . . . .: 0.5 (corresponding to TICKS_PER_SECOND=2 in the disturbance model)
    Simulation campaign index (-s sim). . . . . . .: 1
    Simulation campaigns number (-S sim). . . . . .: 64
    Logging file (-o arg) . . . . . . . . . . . . .: output.txt
    Print coverage each arg traces (-k arg) . . . .: 10
    Signal logging enabled (-l) . . . . . . . . . .: false
    Debugging level (-d arg). . . . . . . . . . . .: 10 (0 nothing, 10 prints commands, 20 prints all)


## Notes On Simulink Driver

First of all, a small introduction on campaigns. All campaigns are stored in subfolder `simulation-campaigns` and named after expression `simCampaign_${s}_of_${S}.txt` where `${s}` is the index of this simulation campaign and `${S}` is the total number of simulation campaigns.
Simulink driver reads a campaign and drives simulation of SUV towards commands contained in such campaign.
Commands can be *save* (`S`), *load* (`L`), *free* (`F`), *run* (`R`), and *inject disturbance* (`I`).
`S1` means *save current system state in file labelled 1* (`1.mat`).
`L1` means *load and restore current system state from file labelled 1*.
`F1` means *remove file labelled 1*.
`R10` means *run simulation for 10 discrete steps*. If sampling time will be set to 0.5 with `run.sh -T 0.5` then `R10` translates into *run simulation for 5 seconds*.
`I1` means *inject disturbance whose index is 1*.

Alas, simulators have limitations. In particular,
Simulators usually do not allow to modify system parameters during simulation. Simulink is not exception. This is a problem, since command `I` implies a variation of system typically yielding to a recompilation of simulation executable.

Fortunately, such limitations can be overcome. In particular, Simulink allows to associate functions to events. As an example, one can associate script `program` to event `StartFcn`, catching the beginning of each run. In this way, at the beginning of each `R` command, `program` will be executed. Since at the beginning of each run the system is in safe state (no one else can change configuration between that moment and the beginning of simulation), the script associated to `StartFcn` is allowed to modify system parameters. If parameters are changed by `program` then an automatic recompilation will follow, before starting simulation.

Specifically. This Simulink Driver, in file `simulator_driver_get_params`, defines a global variable called `currinput` storing important parameters values. Each `I` command changes `currinput`. The program `simulator_driver_set_params.m` is associated to event `StartFcn`. Such program sets SUV parameters following `currinput` values.

For the reasons above, configuration of Simulink driver consists in defining `currinput` in file `simulator_driver_get_params.m` and in writing commands to set SUV parameters from `currinput` in file `simulator_driver_set_params.m`

## Source Code Structure

### `LICENSE.txt`
File containing MIT License.

### `dictionary.txt`
File containing disturbances dictionary.

### `simulation-campaings/`
Folder containing all simulation campaigns.

### `run.sh`
Bash script to run the driver on one of the simulation campaigns in `simulation-campaigns/` folder, with dictionary in `dictionary.txt`. `run.sh` properly sets the MATLAB environment and executes main program `simulator_driver.m`.

### `simulator_driver.m`
Main MATLAB program containing the simulator driver script. It relies on the following scripts.

### `simulator_driver_read_header.m`
Function reading header file of simulation campaign, in order to know simulation campaign parameters.

### `simulator_driver_read_dictionary.m`
Function reading disturbances from `dictionary.txt` and storing them inside a `HashMap` for `simulator_driver.m` convenience.

### `simulator_driver_init.m`
Script containining the definition of global variables, among which the user defined variable `SUV_and_monitor` which is the name of the Simulink model containing the System Under Verification (SUV) and the monitor checking the property.

### `simulator_driver_get_params.m`
Script containing the definition of structure `currinput`.

### `simulator_driver_set_params.m`
Script containing the commands to execute in order to set system blocks from structure `currinput` with values stored in `HashMap` representing the dictionary.

### `simulator_driver_get_property_value.m`
Function returning the value of output of the monitor (0 or 1).

### `simulator_driver_dump_state.m`
Function returning a string representing the actual state of the SUV.

### `simulator_driver_log_signals.m`
When signal logging is on, function called at each command execution in the campaign command for keeping signal logging.

### `simulator_driver_log_signals_save.m`
When signal logging is on, function called at the end of simulation campaign for plotting signals in pictures. Files will be stored in subfolder `['signals-' regexprep(datestr(now), '\W', '-')]`.

### `simulator_driver_split_times_log_in_separate_files.py`
Python script for user convenience. It splits output file `times_log.txt` into files `times_log.F.txt`, `times_log.I.txt`, `times_log.L.txt`, `times_log.R.txt`, `times_log.S.txt` containing execution times for each command. These files can then be used to compute statistics on execution times.