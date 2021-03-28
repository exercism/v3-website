# ETL

This is how to do v2 - v3 ETL

1. Load data into mysql

```bash
mysql -u root -e "drop database website_etl"
mysql -u root -e "create database website_etl"
mysql -u root website_etl < dump-for-v3-etl.sql
```

2. Run ETL

```bash
rails c
```

```ruby
require_relative Rails.root.join('lib/v2_etl/migrate')
V2ETL::Migrate.call
```

3. Fix up Nim
4. Rename reasonml (https://github.com/exercism/reasonml/pull/135)
