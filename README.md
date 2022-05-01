Heck is the Helpful Emulator Construction Kit. It automates management of
iOS and Android emulators for use in flutter testing.

## Features

Heck provides APIs for tasks like:

* creating new virtual iOS and Android devices.
* controlling device form factor and OS version.
* switching device locales.
* starting and stopping devices.
* running flutter driver tests against devices.
* deleting devices when they are no longer necessary.

## Getting started

See the test/e2e directory for examples of how to use Heck.

create\_delete\_test.dart shows how to create and delete emulators.

start\_stop\_android\_test.dart and start\_stop\_ios\_test.dart show how to
start and stop emulators.

flutter\_drive\_android\_test.dart and flutter\_drive\_ios\_test.dart contain
complete examples: creating and starting emulators, running integration tests,
and deleting the emulators afterwards.

## Additional information

Heck is beta software, built as part of a side-project. Bug reports and
contributions are welcome, but no formal support is available.

If you'd like to contribute code, the first step is to clone the repository
and run "dart test test/e2e/\*.dart". That will make sure the code works
properly on your machine. Once the basics are working, send pull requests or
bug reports as neededs.
