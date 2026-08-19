# Quick Templates

See [docs/boilerplate-templates.md](../../docs/boilerplate-templates.md) for full templates.

## New Feature Folder

```
lib/features/<feature>/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubit/
    ├── screens/
    └── widgets/
```

## Cubit State Names

Always use: `{Feature}Initial`, `{Feature}Loading`, `{Feature}Success`, `{Feature}Failure`.

## Translation Key Pattern

```json
"<feature>.<screen>.<element>"
```

Example: `home.popular`, `search.hint`, `common.retry`

## Either/Result in Repository

Repository impl catches exceptions, returns `Left(ServerFailure(...))` or `Right(data)`.

## BlocProvider Placement

- Screen-scoped: wrap in route or screen widget
- App-wide (home tabs): register in `MovieApp` MultiBlocProvider
