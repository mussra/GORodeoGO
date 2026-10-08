# BUILD AND DEPLOY

## Target
Android / Google Play.

## Requirements
Maintain a reproducible development build process.

Define and record:
- Godot version;
- GUT version used for the test suite;
- JDK version required by the Android export;
- Android SDK requirements;
- build configuration;
- package/application identifier;
- signing strategy;
- release configuration.

## CI
Automate where practical:
- restore;
- build;
- tests;
- static checks;
- release artifact generation.

Never store secrets in the repository.

## Release principle
A release candidate must pass build, tests and validation before distribution.

## Store
Prepare:
- application identity;
- icon;
- screenshots;
- description;
- privacy information;
- age/content classification;
- testing tracks;
- release package.

Specific current Google Play requirements must be verified at release time.
