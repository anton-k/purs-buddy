# purs-buddy

Applies purescript compiler suggestions t othe code base.
First run the purescript ide server as background process:

```
> purs ide server
```

After that we can navigate to the project repo and run purs-buddy
to substitute all sugestions:

```
> cd repo
> purs-buddy
```

Note that repo should be git project.
It applies substitution to all files that are tracked by get and are purescript files.

For `ImplicitImport` error/warning it skips the biggest import and treats it as Prelude.
