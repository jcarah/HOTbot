# HOTbot

### HOTbot, a Henry Output Tool

Automate a sequence of [Henry](https://github.com/josephaxisa/henry) pulse, analyze, and vacuum commands and output the results to a common directory.

### Setup

To install HOTbot, clone this repo locally:

```git clone git@github.com:jcarah/HOTbot.git```

Ensure that HOTbot is executable:

```chmod +x hotbot.sh```

Ensure that Henry is installed and running by running ```henry --help```. If any errors are returned, please consult the [Henry](https://github.com/josephaxisa/henry) repository.

Ensure that the path to `config.yml` is referenced in your global [Global Config File](https://github.com/josephaxisa/henry#global-config-file).

### Usage

HOTbot takes three positional arguments:
- **host**: a reference to the host alias in [`config.yml`](https://github.com/josephaxisa/henry#storing-credentials)
- **min_queries**: based on the results of `henry analyze explores`, vacuum explores with at least this many queries.
- **min_unused_fields**: based on the results of `henry analyze explores`, vacuum explores with at least this many unused fields.

Note: you may optionally set `min_queries` and `min_unused_fields` to zero to ensure that all explores are vacuumed. However, also note, that this may take a long time.

### Example

The following command will run HOTbot against localhost and vacuum all explores with at least 100 queries and at least 50 unused fields

```./hotbot.sh localhost 100 50```

### Output

The output of the henry commands will be saved as individual .txt files in a timestamped subdirectory of the output directory. For example:

```
├── hotbot.sh
├── output
│   ├── 2019-01-30_14:20:27
│   │   ├── henry_analyze_explores.txt
│   │   ├── henry_analyze_models.txt
│   │   ├── henry_analyze_projects.txt
│   │   ├── henry_vacuum_explores_snowflake_data::clickstream.txt
│   │   ├── henry_vacuum_explores_thelook::orders.txt
│   │   └── henry_vacuum_models.txt
│   └── 2019-01-30_14:34:03
│       ├── henry_analyze_explores.txt
│       ├── henry_analyze_models.txt
│       ├── henry_analyze_projects.txt
│       ├── henry_pulse.txt
│       ├── henry_vacuum_explores_snowflake_data::clickstream.txt
│       ├── henry_vacuum_explores_thelook::orders.txt
│       └── henry_vacuum_models.txt
└── readme.md
```
