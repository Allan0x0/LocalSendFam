---
name: mysql-migrate
description: Dump a MySQL/MariaDB database without locking it, move it across machines (LAN or local), and import it with progress output and verification. Use when user wants to export/import/copy/migrate a MySQL database, mentions mysqldump, a .sql dump file, or moving a DB between servers.
---

# MySQL dump / import / migrate, safely

The recurring job: a live MySQL/MariaDB DB on one machine (often an Ubuntu LAN server) must be copied to another without locking the source. The recipe below is the answer; adapt names, don't reinvent flags.

## Dump (no locks on InnoDB)

```bash
mysqldump -h <host> -u <user> -p \
  --single-transaction --skip-lock-tables \
  --routines --triggers --events \
  --no-tablespaces \
  <dbname> | gzip > <dbname>-$(date +%F).sql.gz
```

- `--single-transaction` gives a consistent snapshot for InnoDB with no table locks. MyISAM tables are NOT protected by it; check first (`SELECT engine, COUNT(*) FROM information_schema.tables WHERE table_schema='<dbname>' GROUP BY engine;`) and warn if MyISAM is present.
- Progress: pipe through `pv` if installed (`mysqldump ... | pv | gzip > ...`); otherwise `ls -lh` the growing file from another shell.
- Side effects to state up front: brief metadata locks at snapshot start, extra I/O and long-running-transaction load while it runs, and binlog/undo growth on very busy servers. No downtime, no write blocking for InnoDB.

## Move

Same LAN: `scp` / `rsync -avz --progress` the `.sql.gz`. Or dump straight over ssh, no temp file:
`ssh <src> "mysqldump ... | gzip" | gunzip | mysql -h <dst> ... <dbname>`

## Import

```bash
mysql -h <host> -u <user> -p -e "CREATE DATABASE IF NOT EXISTS <dbname> CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
pv <dump>.sql.gz | gunzip | mysql -h <host> -u <user> -p <dbname>
```

- `pv` gives the progress bar (percent + ETA since the file size is known). Without pv: `gunzip -c dump.sql.gz | mysql ...` and watch `SHOW PROCESSLIST`.
- Large imports (hundreds of MB): don't paste into a GUI (Adminer/phpMyAdmin will time out) and don't run from a terminal that buffers huge output (Warp has hung on this); use the plain CLI above, ideally inside `tmux`/`screen` or `nohup` so a dropped connection doesn't kill it.
- Speed-ups for big dumps, session-scoped: `mysql -e "SET GLOBAL ...;"` is not needed; instead prepend `SET autocommit=0; SET unique_checks=0; SET foreign_key_checks=0;` and append the reverse plus `COMMIT;`.

## Windows variants

- `mysqldump`/`mysql` flags are identical; the differences are shell plumbing: no `pv`/`gzip` by default. Use PowerShell: `mysqldump ... > dump.sql` then `Compress-Archive`, or install Git Bash for the pipe-based commands verbatim. WAMP's binaries live under `C:\wamp64\bin\mysql\mysql<ver>\bin\` — use full paths if `mysql` isn't on PATH.

## Verify (always, both sides)

```sql
SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='<dbname>';
SELECT table_name, table_rows FROM information_schema.tables WHERE table_schema='<dbname>' ORDER BY table_rows DESC LIMIT 10;
```

Row counts from `information_schema` are estimates for InnoDB; for the few tables that matter, run exact `SELECT COUNT(*)` on source and destination and compare. Report the comparison table, not just "done".

## Rules

- Never `--lock-all-tables` or stop the source DB unless the user asks for a cold copy.
- Ask before overwriting an existing destination database; `CREATE DATABASE IF NOT EXISTS` plus import into it is additive, `DROP DATABASE` is never implied.
- Credentials: use `-p` (prompt) or an option file; never put the password in the command line where it lands in shell history and transcripts.
