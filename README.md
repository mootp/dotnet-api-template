 # MooTP Template

 ## Technologies

* [ASP.NET Core 6](https://docs.microsoft.com/en-us/aspnet/core/introduction-to-aspnet-core)
* [Entity Framework Core 7](https://docs.microsoft.com/en-us/ef/core/)
* [MediatR](https://github.com/jbogard/MediatR)
* [AutoMapper](https://automapper.org/)
* [Repository and Unit of Work Patterns](https://learn.microsoft.com/en-us/aspnet/mvc/overview/older-versions/getting-started-with-ef-5-using-mvc-4/implementing-the-repository-and-unit-of-work-patterns-in-an-asp-net-mvc-application#the-repository-and-unit-of-work-patterns)

## Getting Started

Uncompleted project, I'll update template and script generate.

## Database Migrations Command

### Add migrations
```
dotnet ef migrations add Initial -s src/moo.Api -p src/moo.Infrastructure
```

### Update migrations
```
dotnet ef database update -s src/moo.Api -p src/moo.Infrastructure
```


## Deploy project
```
dotnet publish -o publish/yyyymmdd-hhmm-moo-api
```

## Credit
* [jasontaylordev/CleanArchitecture](https://github.com/jasontaylordev/CleanArchitecture).
* [ardalis/CleanArchitecture](https://github.com/ardalis/CleanArchitecture)