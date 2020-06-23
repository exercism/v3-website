# Exercism

[![Maintainability](https://api.codeclimate.com/v1/badges/b47ec4d5081d8abb59fa/maintainability)](https://codeclimate.com/github/exercism/v3-website/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b47ec4d5081d8abb59fa/test_coverage)](https://codeclimate.com/github/exercism/v3-website/test_coverage)

This is the WIP website for Exercism v3.

## Local setup

You need the following installed:
- MySQL
- Redis

### OS-Specific

#### Mac

- `brew install libgit2 cmake pkg-config`

### Configure the database

Running these commands inside a mysql console will get a working database setup:

```bash
CREATE USER 'exercism_v3'@'localhost' IDENTIFIED BY 'exercism_v3';
CREATE DATABASE exercism_v3_development;
ALTER DATABASE exercism_v3_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON exercism_v3_development.* TO 'exercism_v3'@'localhost';

CREATE DATABASE exercism_v3_dj_development;
ALTER DATABASE exercism_v3_dj_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON exercism_v3_dj_development.* TO 'exercism_v3'@'localhost';

CREATE DATABASE `exercism_v3_test`;
ALTER DATABASE `exercism_v3_test` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON `exercism_v3_test`.* TO 'exercism_v3'@'localhost';

CREATE DATABASE `exercism_v3_dj_test`;
ALTER DATABASE `exercism_v3_dj_test` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON `exercism_v3_dj_test`.* TO 'exercism_v3'@'localhost';
```

Tests are parallelized so you need a db per processor, so you need to do this for `n` processors.

```bash
GRANT ALL PRIVILEGES ON `exercism_v3_test-0`.* TO 'exercism_v3'@'localhost';
GRANT ALL PRIVILEGES ON `exercism_v3_dj_test-0`.* TO 'exercism_v3'@'localhost';
```

### Running the local servers

We have a Procfile which executes the various commands need to run Exercism locally.
On MacOSX we recommend using `hivemind` to manage this, which can be installed via `brew install hivemind`.

To get everything started you can then run:

```bash
hivemind -p 3000 Procfile.dev
```

### Configure Solargraph

If you'd like to use solargraph, the gem is in the file. You need to run and set `solargraph.useBundler` to `true` in your config. I have this working well with coc-solargraph. [This article](http://blog.jamesnewton.com/setting-up-coc-nvim-for-ruby-development) was helpful for setting it up.

- `bundle exec yard gems`
- `solargraph bundle`

## Testing

### Git Repos

To make a new Git repo for use in tests:

```
mkdir /Users/iHiD/Code/exercism/v3/test/repos/new-repo
cd /Users/iHiD/Code/exercism/v3/test/repos/new-repo
git init --bare

cd ~
git clone file:///Users/iHiD/Code/exercism/v3/test/repos/new-repo exercism-new-git-repo
cd exercism-new-git-repo
echo "{}" > config.json
git add config.json
git commit -m "First commit"
git push origin head
```
