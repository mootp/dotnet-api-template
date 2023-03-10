$projectName = Read-Host -Prompt "Enter project name:"

# Create solution
dotnet new sln -n $projectName

# src folder
$src = "src"

# Create projects
dotnet new classlib -n "$projectName.Domain" -o "$src/$projectName.Domain"
dotnet new classlib -n "$projectName.Application" -o "$src/$projectName.Application"
dotnet new classlib -n "$projectName.Infrastructure" -o "$src/$projectName.Infrastructure"
dotnet new webapi -n "$projectName.Api" -o "$src/$projectName.Api"
# dotnet new xunit -n "$projectName.Tests" -o "$src/$projectName.Tests"

# Add projects to solution
dotnet sln "$projectName.sln" add "$src/$projectName.Domain/$projectName.Domain.csproj"
dotnet sln "$projectName.sln" add "$src/$projectName.Application/$projectName.Application.csproj"
dotnet sln "$projectName.sln" add "$src/$projectName.Infrastructure/$projectName.Infrastructure.csproj"
dotnet sln "$projectName.sln" add "$src/$projectName.Api/$projectName.Api.csproj"
# dotnet sln "$projectName.sln" add "$src/$projectName.Tests/$projectName.Tests.csproj"

# Add reference
dotnet add "$src/$projectName.Api" reference "$src/$projectName.Application"
dotnet add "$src/$projectName.Api" reference "$src/$projectName.Infrastructure"
dotnet add "$src/$projectName.Application" reference "$src/$projectName.Domain"
dotnet add "$src/$projectName.Infrastructure" reference "$src/$projectName.Application"

# Add package
dotnet add "$src\$projectName.Api" package Microsoft.EntityFrameworkCore.Tools;
dotnet add "$src\$projectName.Api" package Microsoft.Extensions.Diagnostics.HealthChecks.EntityFrameworkCore --version 6.0.14;
dotnet add "$src\$projectName.Application" package AutoMapper.Extensions.Microsoft.DependencyInjection;
dotnet add "$src\$projectName.Application" package FluentValidation.DependencyInjectionExtensions;
dotnet add "$src\$projectName.Application" package MediatR.Extensions.Microsoft.DependencyInjection;
dotnet add "$src\$projectName.Application" package Microsoft.EntityFrameworkCore;
dotnet add "$src\$projectName.Application" package System.Linq.Dynamic.Core;
dotnet add "$src\$projectName.Infrastructure" package Npgsql.EntityFrameworkCore.PostgreSQL;
dotnet add "$src\$projectName.Infrastructure" package MailKit;
dotnet add "$src\$projectName.Infrastructure" package Microsoft.Extensions.Options.ConfigurationExtensions;

# Remove file
Remove-Item -Path "$src\$projectName.Api\Controllers\WeatherForecastController.cs"
Remove-Item -Path "$src\$projectName.Api\WeatherForecast.cs"
Remove-Item -Path "$src\$projectName.Api\appsettings.Development.json"
Remove-Item -Path "$src\$projectName.Api\appsettings.json"
Remove-Item -Path "$src\$projectName.Api\program.cs"

Remove-Item -Path "$src\$projectName.Application\Class1.cs"
Remove-Item -Path "$src\$projectName.Domain\Class1.cs"
Remove-Item -Path "$src\$projectName.Infrastructure\Class1.cs"

# Create folder
New-Item -ItemType Directory -Path "$src\$projectName.Api\Controllers\Common"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Common"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Common\Behaviours"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Common\Exceptions"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Common\Helpers"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Common\Mappings"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Common\Models"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\Product"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\Product\Commands"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\Product\Queries"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\Product\DTOs"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\ProductBarcode"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\ProductBarcode\Commands"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\ProductBarcode\Queries"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Fetures\ProductBarcode\DTOs"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Repositories"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Repositories\Common"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Notifications"
New-Item -ItemType Directory -Path "$src\$projectName.Application\Services"
New-Item -ItemType Directory -Path "$src\$projectName.Infrastructure\Data"
New-Item -ItemType Directory -Path "$src\$projectName.Infrastructure\Data\Configurations"
New-Item -ItemType Directory -Path "$src\$projectName.Infrastructure\Repositories"
New-Item -ItemType Directory -Path "$src\$projectName.Infrastructure\Repositories\Common"
New-Item -ItemType Directory -Path "$src\$projectName.Infrastructure\Services"
New-Item -ItemType Directory -Path "$src\$projectName.Domain\Entities"
New-Item -ItemType Directory -Path "$src\$projectName.Domain\Entities\Common"
New-Item -ItemType Directory -Path "$src\$projectName.Domain\Enums"
New-Item -ItemType Directory -Path "$src\$projectName.Domain\Models"
New-Item -ItemType Directory -Path "$src\$projectName.Domain\Settings"

# Api ======================================
$settingContent = @"
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=$projectName-db;User Id=postgres;Password=P@ssLocal;"
  },
  "EmailSettings": {
    "FromEmail": "noreply@email.com",
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": 587,
    "SmtpUser": "noreply",
    "SmtpPass": "P@ssEmail"
  }
}

"@
Set-Content -Path "$src\$projectName.Api\appsettings.json" -Value $settingContent

$settingDevContent = @"
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=$projectName-db;User Id=postgres;Password=P@ssLocal;"
  },
  "EmailSettings": {
    "FromEmail": "noreply@email.com",
    "SmtpHost": "smtp.gmail.com",
    "SmtpPort": 587,
    "SmtpUser": "noreply",
    "SmtpPass": "P@ssEmail"
  }
}

"@
Set-Content -Path "$src\$projectName.Api\appsettings.Development.json" -Value $settingDevContent

$addApi = @"
using $projectName.Infrastructure.Data;

namespace $projectName.Api;

public static class ConfigureServices
{
    public static IServiceCollection AddApi(this IServiceCollection services)
    {
        services.AddHttpContextAccessor();
        services.AddHealthChecks().AddDbContextCheck<AppDbContext>();

        return services;
    }
}

"@
Set-Content -Path "$src\$projectName.Api\ConfigureServices.cs" -Value $addApi

$programContent = @"
using $projectName.Api;
using $projectName.Application;
using $projectName.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddApi();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHealthChecks("/health");

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

"@
Set-Content -Path "$src\$projectName.Api\program.cs" -Value $programContent

$commonApiContent = @"
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace $projectName.Api.Controllers.Common;

[Route("[controller]")]
[ApiController]
public class BaseApiController : ControllerBase
{
    private IMediator _mediator = null!;

    protected IMediator Mediator => _mediator ??= HttpContext.RequestServices.GetRequiredService<IMediator>();
}

"@
Set-Content -Path "$src\$projectName.Api\Controllers\Common\CommonController.cs" -Value $commonApiContent

$prdApiContent = @"
using Microsoft.AspNetCore.Mvc;
using $projectName.Api.Controllers.Common;
using $projectName.Application.Common.Models;
using $projectName.Application.Fetures.Product.Commands;
using $projectName.Application.Fetures.Product.Queries;
using $projectName.Application.Fetures.Product.DTOs;

namespace $projectName.Api.Controllers;

public class ProductController : BaseApiController
{
    [HttpGet("[action]")]
    public async Task<ActionResult<Pagination<ProductDto>>> ProductList([FromQuery] ProductWithPaginationQuery query)
    {
        return await Mediator.Send(query);
    }

    [HttpGet("[action]/{id}")]
    public async Task<ActionResult<ProductDto>> ProductDetail(Guid id)
    {
        var query = new ProductDetailQuery { Id = id };
        return await Mediator.Send(query);
    }

    [HttpPost("[action]")]
    public async Task<ActionResult<Guid>> ProductCreate(ProductCreateCommand command)
    {
        var id = await Mediator.Send(command);
        await Mediator.Publish(new ProductCreateNotification { productId = id });
        return id;
    }

    [HttpPut("[action]/{id}")]
    public async Task<ActionResult> ProductUpdate(Guid id, ProductUpdateCommand command)
    {
        if (id != command.Id)
        {
            return BadRequest();
        }

        await Mediator.Send(command);

        return NoContent();
    }

    [HttpDelete("[action]/{id}")]
    public async Task<ActionResult> ProductDelete(Guid id)
    {
        await Mediator.Send(new ProductDeleteCommand { Id = id });

        return NoContent();
    }

}

"@
Set-Content -Path "$src\$projectName.Api\Controllers\ProductController.cs" -Value $prdApiContent

$prdBarcodeApiContent = @"
using Microsoft.AspNetCore.Mvc;
using $projectName.Api.Controllers.Common;
using $projectName.Application.Common.Models;
using $projectName.Application.Fetures.Product.Commands;
using $projectName.Application.Fetures.Product.Queries;

namespace $projectName.Api.Controllers;

public class ProductBarcodeController : BaseApiController
{
    [HttpGet("[action]")]
    public async Task<ActionResult<Pagination<ProductBarcodeDto>>> ProductBarcodeList([FromQuery] ProductBarcodeWithPaginationQuery query)
    {
        return await Mediator.Send(query);
    }

    [HttpGet("[action]/{id}")]
    public async Task<ActionResult<ProductBarcodeDto>> ProductBarcodeDetail(Guid id)
    {
        var query = new ProductBarcodeDetailQuery { Id = id };
        return await Mediator.Send(query);
    }

    [HttpPost("[action]")]
    public async Task<ActionResult<Guid>> ProductBarcodeCreate(ProductBarcodeCreateCommand command)
    {
        return await Mediator.Send(command);
    }

    [HttpPut("[action]/{id}")]
    public async Task<ActionResult> ProductBarcodeUpdate(Guid id, ProductBarcodeUpdateCommand command)
    {
        if (id != command.Id)
        {
            return BadRequest();
        }

        await Mediator.Send(command);

        return NoContent();
    }

    [HttpDelete("[action]/{id}")]
    public async Task<ActionResult> ProductBarcodeDelete(Guid id)
    {
        await Mediator.Send(new ProductBarcodeDeleteCommand { Id = id });

        return NoContent();
    }

}

"@
Set-Content -Path "$src\$projectName.Api\Controllers\ProductBarcodeController.cs" -Value $prdBarcodeApiContent

# Application ======================================
$loggingBehaviour = @"
using MediatR;
using System.Diagnostics;
using Microsoft.Extensions.Logging;

namespace $projectName.Application.Common.Behaviours;

public class LoggingBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse> where TRequest : IRequest<TResponse>
{
    private readonly Stopwatch _timer;
    private readonly ILogger<TRequest> _logger;

    public LoggingBehavior(ILogger<TRequest> logger)
    {
        _timer = new Stopwatch();

        _logger = logger;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        var requestName = typeof(TRequest).Name;
        _logger.LogInformation("----- Request| {@datetime} | 0  | {@name} | {@request}", DateTime.Now, requestName, request);

        _timer.Start();
        var response = await next();
        _timer.Stop();

        var responseName = typeof(TResponse).Name;
        var seconds = _timer.ElapsedMilliseconds;
        _logger.LogInformation("----- Response | {@datetime} | {@sec} | {@name} | {@response}", DateTime.Now, seconds, responseName, response);

        return response;
    }
}
"@
Set-Content -Path "$src\$projectName.Application\Common\Behaviours\LoggingBehaviour.cs" -Value $loggingBehaviour

$notFoundException = @"

namespace $projectName.Application.Common.Exceptions;

public class NotFoundException : Exception
{
    public NotFoundException()
        : base()
    {
    }

    public NotFoundException(string message)
        : base(message)
    {
    }

    public NotFoundException(string message, Exception innerException)
        : base(message, innerException)
    {
    }

    public NotFoundException(string name, object key)
        : base($"Entity \"{name}\" ({key}) was not found.")
    {
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Common\Exceptions\NotFoundException.cs" -Value $notFoundException

$parameterSubstitutionVisitor = @"
using System.Linq.Expressions;

// https://github.com/dotnet/efcore/issues/10834#issuecomment-362221156

namespace $projectName.Application.Common.Helpers;

internal static class QueryBuilderHelpers
{
    public static IQueryable<T> WhereAny<T>(this IQueryable<T> queryable, params Expression<Func<T, bool>>[] predicates)
    {
        var parameter = Expression.Parameter(typeof(T));
        return queryable.Where(
            Expression.Lambda<Func<T, bool>>(
                predicates.Aggregate<Expression<Func<T, bool>>,
                Expression>(null!, (current, predicate) =>
                {
                    var visitor = new ParameterSubstitutionVisitor(predicate.Parameters[0], parameter);
                    return current != null ? Expression.OrElse(current, visitor.Visit(predicate.Body)) : visitor.Visit(predicate.Body);
                }
                ), parameter)
            );
    }

    private class ParameterSubstitutionVisitor : ExpressionVisitor
    {
        private readonly ParameterExpression _destination;
        private readonly ParameterExpression _source;

        public ParameterSubstitutionVisitor(ParameterExpression source, ParameterExpression destination)
        {
            _source = source;
            _destination = destination;
        }

        protected override Expression VisitParameter(ParameterExpression node)
        {
            return ReferenceEquals(node, _source) ? _destination : base.VisitParameter(node);
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Common\Helpers\ParameterSubstitutionVisitor.cs" -Value $parameterSubstitutionVisitor

$iMapForm = @"
using AutoMapper;

namespace $projectName.Application.Common.Mappings;

public interface IMapFrom<T>
{
    void Mapping(Profile profile) => profile.CreateMap(typeof(T), GetType());
}

"@
Set-Content -Path "$src\$projectName.Application\Common\Mappings\IMapForm.cs" -Value $iMapForm

$mappingProfile = @"
using System.Reflection;
using AutoMapper;

namespace $projectName.Application.Common.Mappings;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        ApplyMappingsFromAssembly(Assembly.GetExecutingAssembly());
    }

    private void ApplyMappingsFromAssembly(Assembly assembly)
    {
        var mapFromType = typeof(IMapFrom<>);

        var mappingMethodName = nameof(IMapFrom<object>.Mapping);

        bool HasInterface(Type t) => t.IsGenericType && t.GetGenericTypeDefinition() == mapFromType;

        var types = assembly.GetExportedTypes().Where(t => t.GetInterfaces().Any(HasInterface)).ToList();

        var argumentTypes = new Type[] { typeof(Profile) };

        foreach (var type in types)
        {
            var instance = Activator.CreateInstance(type);

            var methodInfo = type.GetMethod(mappingMethodName);

            if (methodInfo != null)
            {
                methodInfo.Invoke(instance, new object[] { this });
            }
            else
            {
                var interfaces = type.GetInterfaces().Where(HasInterface).ToList();

                if (interfaces.Count > 0)
                {
                    foreach (var @interface in interfaces)
                    {
                        var interfaceMethodInfo = @interface.GetMethod(mappingMethodName, argumentTypes);

                        interfaceMethodInfo?.Invoke(instance, new object[] { this });
                    }
                }
            }
        }
    }
}
"@
Set-Content -Path "$src\$projectName.Application\Common\Mappings\MappingProfile.cs" -Value $mappingProfile

# ======================================

$productCreateCommand = @"

using MediatR;
using AutoMapper;
using $projectName.Domain.Entities;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Commands;

public class ProductCreateCommand : IRequest<Guid>
{
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }
}

public class ProductCreateCommandHandler : IRequestHandler<ProductCreateCommand, Guid>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductCreateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Guid> Handle(ProductCreateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var entity = _mapper.Map<MasterProduct>(request);

            await _unitOfWork.MasterProductRepo.AddAsync(entity);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return entity.Id;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw ex;
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\Product\Commands\ProductCreateCommand.cs" -Value $productCreateCommand

$productDeleteCommand = @"
using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Application.Common.Exceptions;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Commands;

public class ProductDeleteCommand : IRequest
{
    public Guid Id { get; set; }
}

public class ProductDeleteCommandHandler : IRequestHandler<ProductDeleteCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductDeleteCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductDeleteCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var repo = _unitOfWork.MasterProductRepo;

            var data = await repo.GetQueryable(true).FirstOrDefaultAsync(x => x.Id == request.Id, cancellationToken);

            if (data == null)
            {
                throw new NotFoundException(nameof(MasterProduct), request.Id);
            }

            _unitOfWork.MasterProductRepo.Remove(data);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return Unit.Value;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw ex;
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\Product\Commands\ProductDeleteCommand.cs" -Value $productDeleteCommand

$productUpdateCommand = @"
using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Application.Common.Exceptions;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Commands;

public class ProductUpdateCommand : IRequest
{
    public Guid Id { get; set; }
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }
    
}

public class ProductUpdateCommandHandler : IRequestHandler<ProductUpdateCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductUpdateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductUpdateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var repo = _unitOfWork.MasterProductRepo;

            var data = await repo.GetQueryable(true).FirstOrDefaultAsync(x => x.Id == request.Id, cancellationToken);

            if (data == null)
            {
                throw new NotFoundException(nameof(MasterProduct), request.Id);
            }

            _mapper.Map(request, data);

            _unitOfWork.MasterProductRepo.Update(data);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return Unit.Value;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw ex;
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\Product\Commands\ProductUpdateCommand.cs" -Value $productUpdateCommand

$productDetailQuery = @"
using AutoMapper;
using MediatR;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Queries;

public class ProductDetailQuery : IRequest<ProductDto>
{
    public Guid Id { get; set; }
}

public class ProductDetailQueryHandler : IRequestHandler<ProductDetailQuery, ProductDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductDetailQueryHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<ProductDto> Handle(ProductDetailQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductRepo.GetQueryable(true).FirstOrDefault(x => x.Id == request.Id);
        
        var rtn =  _mapper.Map<ProductDto>(query);

        return await Task.FromResult(rtn);
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\Product\Queries\ProductDetailQuery.cs" -Value $productDetailQuery

$productDto = @"
using AutoMapper;
using $projectName.Application.Common.Mappings;
using $projectName.Application.Fetures.Product.Commands;
using $projectName.Domain.Entities;

namespace $projectName.Application.Fetures.Product.Queries;

public class ProductDto : IMapFrom<MasterProduct>
{
    public Guid Id { get; set; }
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }
    public IList<ProductBarcodeDto>? Barcode { get; set; }

    public void Mapping(Profile profile)
    {
        profile.CreateMap<MasterProduct, ProductDto>();
        profile.CreateMap<ProductCreateCommand, MasterProduct>();
        profile.CreateMap<ProductUpdateCommand, MasterProduct>();
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\Product\Queries\ProductDto.cs" -Value $productDto

$productListQuery = @"
using MediatR;
using AutoMapper;
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using $projectName.Application.Common.Helpers;
using $projectName.Application.Repositories.Common;
using $projectName.Application.Services;
using $projectName.Domain.Entities;
using $projectName.Domain.Models;

namespace $projectName.Application.Fetures.Product.Queries;

public class ProductWithPaginationQuery : IRequest<Pagination<ProductDto>>
{
    public string? Search { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 10;
    public string? SortColumn { get; set; }
    public string? SortDirection { get; set; }
}

public class ProductWithPaginationQueryHandler : IRequestHandler<ProductWithPaginationQuery, Pagination<ProductDto>>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    private readonly IPaginationService _paginationSrv;

    public ProductWithPaginationQueryHandler(IUnitOfWork unitOfWork, IMapper mapper, IPaginationService paginationSrv)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _paginationSrv = paginationSrv;
    }

    public async Task<Pagination<ProductDto>> Handle(ProductWithPaginationQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductRepo.GetQueryable(false);

        if (request.Search != null)
        {
            string[] words = request.Search.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            query = query.WhereAny(words.Select(w => (Expression<Func<MasterProduct, bool>>)(x =>
                EF.Functions.Like(x.Code.ToLower().Trim(), "%" + w.ToLower().Trim() + "%") ||
                EF.Functions.Like(x.Name.ToLower().Trim(), "%" + w.ToLower().Trim() + "%") ||
                EF.Functions.Like((x.Desc ?? "").ToLower().Trim(), "%" + w.ToLower().Trim() + "%")
            )).ToArray());
        }

        return await _paginationSrv.GetPagination<ProductDto, MasterProduct>(query, request.PageNumber, request.PageSize, request.SortColumn, request.SortDirection);
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\Product\Queries\ProductListQuery.cs" -Value $productListQuery

# ======================================

$productBarcodeCreateCommand = @"

using MediatR;
using AutoMapper;
using $projectName.Domain.Entities;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Commands;

public class ProductBarcodeCreateCommand : IRequest<Guid>
{
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }
}

public class ProductBarcodeCreateCommandHandler : IRequestHandler<ProductBarcodeCreateCommand, Guid>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeCreateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Guid> Handle(ProductBarcodeCreateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var entity = _mapper.Map<MasterProductBarcode>(request);

            await _unitOfWork.MasterProductBarcodeRepo.AddAsync(entity);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return entity.Id;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw ex;
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\ProductBarcode\Commands\ProductBarcodeCreateCommand.cs" -Value $productBarcodeCreateCommand

$productBarcodeDeleteCommand = @"
using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Application.Common.Exceptions;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Commands;

public class ProductBarcodeDeleteCommand : IRequest
{
    public Guid Id { get; set; }
}

public class ProductBarcodeDeleteCommandHandler : IRequestHandler<ProductBarcodeDeleteCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeDeleteCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductBarcodeDeleteCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var repo = _unitOfWork.MasterProductBarcodeRepo;

            var data = await repo.GetQueryable(true).FirstOrDefaultAsync(x => x.Id == request.Id, cancellationToken);

            if (data == null)
            {
                throw new NotFoundException(nameof(MasterProductBarcode), request.Id);
            }

            _unitOfWork.MasterProductBarcodeRepo.Remove(data);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return Unit.Value;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw ex;
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\ProductBarcode\Commands\ProductBarcodeDeleteCommand.cs" -Value $productBarcodeDeleteCommand

$productBarcodeUpdateCommand = @"
using MediatR;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Application.Common.Exceptions;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Commands;

public class ProductBarcodeUpdateCommand : IRequest
{
    public Guid Id { get; set; }
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }
    
}

public class ProductBarcodeUpdateCommandHandler : IRequestHandler<ProductBarcodeUpdateCommand>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeUpdateCommandHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Unit> Handle(ProductBarcodeUpdateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync();

            var repo = _unitOfWork.MasterProductBarcodeRepo;

            var data = await repo.GetQueryable(true).FirstOrDefaultAsync(x => x.Id == request.Id, cancellationToken);

            if (data == null)
            {
                throw new NotFoundException(nameof(MasterProductBarcode), request.Id);
            }

            _mapper.Map(request, data);

            _unitOfWork.MasterProductBarcodeRepo.Update(data);

            await _unitOfWork.SaveChangesAsync(cancellationToken);

            await _unitOfWork.CommitAsync(cancellationToken);

            return Unit.Value;

        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackAsync();
            throw ex;
        }
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\ProductBarcode\Commands\ProductBarcodeUpdateCommand.cs" -Value $productBarcodeUpdateCommand

$productBarcodeDetailQuery = @"
using MediatR;
using AutoMapper;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Fetures.Product.Queries;

public class ProductBarcodeDetailQuery : IRequest<ProductBarcodeDto>
{
    public Guid Id { get; set; }
}

public class ProductBarcodeDetailQueryHandler : IRequestHandler<ProductBarcodeDetailQuery, ProductBarcodeDto>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public ProductBarcodeDetailQueryHandler(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<ProductBarcodeDto> Handle(ProductBarcodeDetailQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductBarcodeRepo.GetQueryable(true).FirstOrDefault(x => x.Id == request.Id);
        
        var rtn =  _mapper.Map<ProductBarcodeDto>(query);

        return await Task.FromResult(rtn);
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\ProductBarcode\Queries\ProductBarcodeDetailQuery.cs" -Value $productBarcodeDetailQuery

$productBarcodeDto = @"
using AutoMapper;
using $projectName.Application.Common.Mappings;
using $projectName.Application.Fetures.Product.Commands;
using $projectName.Domain.Entities;

namespace $projectName.Application.Fetures.Product.Queries;

public class ProductBarcodeDto : IMapFrom<MasterProductBarcode>
{
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }

    public void Mapping(Profile profile)
    {
        profile.CreateMap<MasterProductBarcode, ProductBarcodeDto>();
        profile.CreateMap<ProductBarcodeCreateCommand, MasterProductBarcode>();
        profile.CreateMap<ProductBarcodeUpdateCommand, MasterProductBarcode>();
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\ProductBarcode\Queries\ProductBarcodeDto.cs" -Value $productBarcodeDto

$productBarcodeListQuery = @"
using MediatR;
using AutoMapper;
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using $projectName.Application.Common.Helpers;
using $projectName.Application.Repositories.Common;
using $projectName.Application.Services;
using $projectName.Domain.Entities;
using $projectName.Domain.Models;

namespace $projectName.Application.Fetures.Product.Queries;

public class ProductBarcodeWithPaginationQuery : IRequest<Pagination<ProductBarcodeDto>>
{
    public Guid ProductId { get; set; }
    public string? Search { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 10;
    public string? SortColumn { get; set; }
    public string? SortDirection { get; set; }
}

public class ProductBarcodeWithPaginationQueryHandler : IRequestHandler<ProductBarcodeWithPaginationQuery, Pagination<ProductBarcodeDto>>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    private readonly IPaginationService _paginationSrv;

    public ProductBarcodeWithPaginationQueryHandler(IUnitOfWork unitOfWork, IMapper mapper, IPaginationService paginationSrv)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _paginationSrv = paginationSrv;
    }

    public async Task<Pagination<ProductBarcodeDto>> Handle(ProductBarcodeWithPaginationQuery request, CancellationToken cancellationToken)
    {
        var query = _unitOfWork.MasterProductBarcodeRepo.GetQueryable(false).Where(x => x.ProductId == request.ProductId);

        if (request.Search != null)
        {
            string[] words = request.Search.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            query = query.WhereAny(words.Select(w => (Expression<Func<MasterProductBarcode, bool>>)(x =>
                EF.Functions.Like(x.Barcode.ToLower().Trim(), "%" + w.ToLower().Trim() + "%") ||
                EF.Functions.Like((x.Desc ?? "").ToLower().Trim(), "%" + w.ToLower().Trim() + "%")
            )).ToArray());
        }

        return await _paginationSrv.GetPagination<ProductBarcodeDto, MasterProductBarcode>(query, request.PageNumber, request.PageSize, request.SortColumn, request.SortDirection);
    }
}

"@
Set-Content -Path "$src\$projectName.Application\Fetures\ProductBarcode\Queries\ProductBarcodeListQuery.cs" -Value $productBarcodeListQuery

# ======================================

$productCreateNotification = @"
using MediatR;
using AutoMapper;
using $projectName.Application.Repositories.Common;
using $projectName.Application.Services;

namespace $projectName.Application.Notifications;

public record ProductCreateNotification : INotification
{
    public Guid productId { get; set; }
};

public class ProductCreateNotificationHandler : INotificationHandler<ProductCreateNotification>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    private readonly IEmailService _emailSrv;

    public ProductCreateNotificationHandler(IUnitOfWork unitOfWork, IMapper mapper, IEmailService emailSrv)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _emailSrv = emailSrv;
    }
    public async Task Handle(ProductCreateNotification notification, CancellationToken cancellationToken)
    {
        await _emailSrv.SendEmailProductAdd(notification.productId);
        await Task.CompletedTask;
    }
}
"@
Set-Content -Path "$src\$projectName.Application\Notifications\ProductCreateNotification.cs" -Value $productCreateNotification


# ======================================
$iBaseRepository = @"
using System.Linq.Expressions;

namespace $projectName.Application.Repositories.Common;

public interface IBaseRepository<TEntity> where TEntity : class
{
    void Add(TEntity entity);
    void AddRange(IEnumerable<TEntity> entities);
    Task AddAsync(TEntity entity);
    Task AddRangeAsync(IEnumerable<TEntity> entities);
    void Update(TEntity entity);
    void UpdateRange(IEnumerable<TEntity> entities);
    void Remove(TEntity entity);
    void RemoveRange(IEnumerable<TEntity> entities);
    TEntity? Find(params object?[]? keyValues);
    Task<TEntity?> FindAsync(params object[] keyValues);
    IQueryable<TEntity> Where(Expression<Func<TEntity, bool>> predicate);
    TEntity? FirstOrDefault();
    TEntity? FirstOrDefault(Expression<Func<TEntity, bool>> predicate);
    Task<TEntity?> FirstOrDefaultAsync();
    Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate);
    TEntity? SingleOrDefault();
    TEntity? SingleOrDefault(Expression<Func<TEntity, bool>> predicate);
    Task<TEntity?> SingleOrDefaultAsync();
    Task<TEntity?> SingleOrDefaultAsync(Expression<Func<TEntity, bool>> predicate);

}

"@
Set-Content -Path "$src\$projectName.Application\Repositories\Common\IBaseRepository.cs" -Value $iBaseRepository

$iUnitOfWork = @"

namespace $projectName.Application.Repositories.Common;

public interface IUnitOfWork : IAsyncDisposable
{
    int SaveChanges();
    Task<int> SaveChangesAsync();
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    void BeginTransaction();
    Task BeginTransactionAsync();
    Task BeginTransactionAsync(CancellationToken cancellationToken = default);
    void Commit();
    Task CommitAsync();
    Task CommitAsync(CancellationToken cancellationToken = default);
    void Rollback();
    Task RollbackAsync();
    Task RollbackAsync(CancellationToken cancellationToken = default);
    IBaseRepository<TEntity> GetRepository<TEntity>() where TEntity : class;
    //===============
    public IMasterProductRepository MasterProductRepo { get; }
    public IMasterProductBarcodeRepository MasterProductBarcodeRepo { get; }

}
"@
Set-Content -Path "$src\$projectName.Application\Repositories\Common\IUnitOfWork.cs" -Value $iUnitOfWork

$iMasterProductBarcodeRepository = @"
using $projectName.Domain.Entities;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Repositories;
public interface IMasterProductBarcodeRepository : IBaseRepository<MasterProductBarcode>
{
    IQueryable<MasterProductBarcode> GetQueryable(bool includeDetail = false);
}

"@
Set-Content -Path "$src\$projectName.Application\Repositories\IMasterProductBarcodeRepository.cs" -Value $iMasterProductBarcodeRepository

$iMasterProductRepository = @"
using $projectName.Domain.Entities;
using $projectName.Application.Repositories.Common;

namespace $projectName.Application.Repositories;
public interface IMasterProductRepository : IBaseRepository<MasterProduct>
{
    IQueryable<MasterProduct> GetQueryable(bool includeDetail = false);
}

"@
Set-Content -Path "$src\$projectName.Application\Repositories\IMasterProductRepository.cs" -Value $iMasterProductRepository

# ======================================

$iPaginationService = @"
using $projectName.Domain.Models;

namespace $projectName.Application.Services;
public interface IPaginationService
{
    Task<Pagination<T>> GetPagination<T, U>(IQueryable<U> query, int? pageNumber, int? pageSize, string? sortColumn, string? sortDirection);
}

"@
Set-Content -Path "$src\$projectName.Application\Services\IPaginationService.cs" -Value $iPaginationService

$iEmailService = @"

namespace $projectName.Application.Services;
public interface IEmailService
{
    Task SendEmailProductAdd(Guid productId);
}

"@
Set-Content -Path "$src\$projectName.Application\Services\IEmailService.cs" -Value $iEmailService


$addApplication = @"
using MediatR;
using FluentValidation;
using System.Reflection;
using Microsoft.Extensions.DependencyInjection;
using $projectName.Application.Common.Behaviours;

namespace $projectName.Application;

public static class ConfigureServices
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddAutoMapper(Assembly.GetExecutingAssembly());
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
        services.AddMediatR(Assembly.GetExecutingAssembly());

        services.AddTransient(typeof(IPipelineBehavior<,>), typeof(LoggingBehavior<,>));
        
        return services;
    }
}

"@
Set-Content -Path "$src\$projectName.Application\ConfigureServices.cs" -Value $addApplication

# ======================================

# Infrastructure ======================================
$appDbContext = @"
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Infrastructure.Data.Configurations;

namespace $projectName.Infrastructure.Data;

public class AppDbContext : DbContext
{

    public DbSet<MasterProduct> MasterProduct { get; set; } = null!;
    public DbSet<MasterProductBarcode> MasterProductBarcode { get; set; } = null!;

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfiguration(new MasterProductConfig());
    }

}

"@
Set-Content -Path "$src\$projectName.Infrastructure\Data\AppDbContext.cs" -Value $appDbContext

$productConfig = @"
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using $projectName.Domain.Entities;

namespace $projectName.Infrastructure.Data.Configurations;
public class MasterProductConfig : IEntityTypeConfiguration<MasterProduct>
{
    public void Configure(EntityTypeBuilder<MasterProduct> builder)
    {

        builder.HasData(new MasterProduct
        {
            Id = new Guid("c40c24f4-62cf-4f4c-b9fd-bde886d56711"),
            Code = "PRD-001",
            Name = "Product 001",
            Desc = "PRD-001 | Product 001",
        });

        builder.HasData(new MasterProduct
        {
            Id = new Guid("b6863e51-b592-4d1f-b7c1-eb5aff413c87"),
            Code = "PRD-002",
            Name = "Product 002",
            Desc = "PRD-002 | Product 002",
        });
    }
}
"@
Set-Content -Path "$src\$projectName.Infrastructure\Data\Configurations\ProductConfig.cs" -Value $productConfig

$baseRepository = @"
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using $projectName.Application.Repositories.Common;

namespace $projectName.Infrastructure.Repositories.Common;

public class BaseRepository<TEntity> : IBaseRepository<TEntity> where TEntity : class
{
    internal DbSet<TEntity> _dbSet;
    protected readonly DbContext _context;

    public BaseRepository(DbContext context)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
        _dbSet = _context.Set<TEntity>();
    }

    public void Add(TEntity entity) => _dbSet.Add(entity);
    public void AddRange(IEnumerable<TEntity> entities) => _dbSet.AddRange(entities);
    public async Task AddAsync(TEntity entity) => await _dbSet.AddAsync(entity);
    public async Task AddRangeAsync(IEnumerable<TEntity> entities) => await _dbSet.AddRangeAsync(entities);
    public void Update(TEntity entity) => _dbSet.Update(entity);
    public void UpdateRange(IEnumerable<TEntity> entities) => _dbSet.UpdateRange(entities);
    public void Remove(TEntity entity) => _dbSet.Remove(entity);
    public void RemoveRange(IEnumerable<TEntity> entities) => _dbSet.RemoveRange(entities);
    public TEntity? Find(params object?[]? keyValues) => _dbSet.Find(keyValues);
    public async Task<TEntity?> FindAsync(params object[] keyValues) => await _dbSet.FindAsync(keyValues);
    public IQueryable<TEntity> Where(Expression<Func<TEntity, bool>> predicate) => _dbSet.Where(predicate);
    public TEntity? FirstOrDefault() => _dbSet.FirstOrDefault();
    public TEntity? FirstOrDefault(Expression<Func<TEntity, bool>> predicate) => _dbSet.FirstOrDefault(predicate);
    public async Task<TEntity?> FirstOrDefaultAsync() => await _dbSet.FirstOrDefaultAsync();
    public async Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate) => await _dbSet.FirstOrDefaultAsync(predicate);
    public TEntity? SingleOrDefault() => _dbSet.SingleOrDefault();
    public TEntity? SingleOrDefault(Expression<Func<TEntity, bool>> predicate) => _dbSet.SingleOrDefault(predicate);
    public async Task<TEntity?> SingleOrDefaultAsync() => await _dbSet.SingleOrDefaultAsync();
    public async Task<TEntity?> SingleOrDefaultAsync(Expression<Func<TEntity, bool>> predicate) => await _dbSet.SingleOrDefaultAsync(predicate);
}

"@
Set-Content -Path "$src\$projectName.Infrastructure\Repositories\Common\BaseRepository.cs" -Value $baseRepository

$unitOfWork = @"
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using $projectName.Application.Repositories;
using $projectName.Application.Repositories.Common;

namespace $projectName.Infrastructure.Repositories.Common;
public class UnitOfWork<TDbContext> : IUnitOfWork where TDbContext : DbContext
{
    private readonly TDbContext _context;
    private IDbContextTransaction _objTran = null!;
    private Dictionary<Type, object> repositories = null!;
    //===============
    public IMasterProductRepository MasterProductRepo { get; }
    public IMasterProductBarcodeRepository MasterProductBarcodeRepo { get; }

    public UnitOfWork(TDbContext context)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
		
        MasterProductRepo = new MasterProductRepository<TDbContext>(_context);
        MasterProductBarcodeRepo = new MasterProductBarcodeRepository<TDbContext>(_context);
    }

    public async ValueTask DisposeAsync()
    {
        await _context.DisposeAsync();
    }

    public int SaveChanges()
    {
        return _context.SaveChanges();
    }

    public async Task<int> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync();
    }

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        return await _context.SaveChangesAsync(cancellationToken);
    }

    public void BeginTransaction()
    {
        _objTran = _context.Database.BeginTransaction();
    }

    public async Task BeginTransactionAsync()
    {
        _objTran = await _context.Database.BeginTransactionAsync();
    }

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
    {
        _objTran = await _context.Database.BeginTransactionAsync(cancellationToken);
    }

    public void Commit()
    {
        _objTran.Commit();
    }

    public async Task CommitAsync()
    {
        await _objTran.CommitAsync();
    }

    public async Task CommitAsync(CancellationToken cancellationToken = default)
    {
        await _objTran.CommitAsync(cancellationToken);
    }

    public void Rollback()
    {
        _objTran.Rollback();
        _objTran.Dispose();
    }

    public async Task RollbackAsync()
    {
        await _objTran.RollbackAsync();
        await _objTran.DisposeAsync();
    }

    public async Task RollbackAsync(CancellationToken cancellationToken = default)
    {
        await _objTran.RollbackAsync(cancellationToken);
        await _objTran.DisposeAsync();
    }

    public IBaseRepository<TEntity> GetRepository<TEntity>() where TEntity : class
    {
        if (repositories == null)
        {
            repositories = new Dictionary<Type, object>();
        }

        var type = typeof(TEntity);
        if (!repositories.ContainsKey(type))
        {
            repositories[type] = new BaseRepository<TEntity>(_context);
        }

        return (IBaseRepository<TEntity>)repositories[type];
    }

}

"@
Set-Content -Path "$src\$projectName.Infrastructure\Repositories\Common\UnitOfWork.cs" -Value $unitOfWork

$masterProductBarcodeRepository = @"
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Application.Repositories;
using $projectName.Infrastructure.Repositories.Common;

namespace $projectName.Infrastructure.Repositories;
public class MasterProductBarcodeRepository<TDbContext> : BaseRepository<MasterProductBarcode>, IMasterProductBarcodeRepository where TDbContext : DbContext
{
    public MasterProductBarcodeRepository(TDbContext context) : base(context)
    {
    }

    private IQueryable<MasterProductBarcode> Query(bool includeDetail = false)
    {
        if (includeDetail)
        {
            return _dbSet;
        }

        return _dbSet;
    }


    public IQueryable<MasterProductBarcode> GetQueryable(bool includeDetail = false)
    {
        return Query(includeDetail).AsNoTracking();
    }
}
"@
Set-Content -Path "$src\$projectName.Infrastructure\Repositories\MasterProductBarcodeRepository.cs" -Value $masterProductBarcodeRepository

$masterProductRepository = @"
using Microsoft.EntityFrameworkCore;
using $projectName.Domain.Entities;
using $projectName.Application.Repositories;
using $projectName.Infrastructure.Repositories.Common;

namespace $projectName.Infrastructure.Repositories;
public class MasterProductRepository<TDbContext> : BaseRepository<MasterProduct>, IMasterProductRepository where TDbContext : DbContext
{
    public MasterProductRepository(TDbContext context) : base(context)
    {
    }

    private IQueryable<MasterProduct> Query(bool includeDetail = false)
    {
        if (includeDetail)
        {
            return _dbSet.Include(o => o.Barcode);
        }

        return _dbSet;
    }


    public IQueryable<MasterProduct> GetQueryable(bool includeDetail = false)
    {
        return Query(includeDetail).AsNoTracking();
    }
}
"@
Set-Content -Path "$src\$projectName.Infrastructure\Repositories\MasterProductRepository.cs" -Value $masterProductRepository

$paginationService = @"
using AutoMapper;
using System.Linq.Dynamic.Core;
using $projectName.Domain.Models;
using $projectName.Application.Services;

namespace $projectName.Infrastructure.Services;
public class PaginationService : IPaginationService
{
    private readonly IMapper _mapper;
    public PaginationService(IMapper mapper)
    {
        _mapper = mapper;
    }

    public async Task<Pagination<T>> GetPagination<T, U>(IQueryable<U> query, int? pageNumber, int? pageSize, string? sortColumn, string? sortDirection)
    {
        var total = query.Count();
        if (sortColumn != null && sortDirection != null)
        {
            query = query.OrderBy(sortColumn + " " + sortDirection);
        }
        if (pageNumber != null && pageSize != null)
        {
            query = query.Skip(((pageNumber ?? 1) - 1) * (pageSize ?? 10)).Take((pageSize ?? 10));
        }

        var tmp = query.ToList();
        var res = new List<T>();
        if (tmp != null)
        {
            res = _mapper.Map<List<T>>(tmp);
        }

        var rtn = await Task.FromResult(new Pagination<T>
        {
            Total = total,
            Results = res
        });

        return rtn;
    }
}

"@
Set-Content -Path "$src\$projectName.Infrastructure\Services\PaginationService.cs" -Value $paginationService

$emailService = @"
using AutoMapper;
using MimeKit;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using $projectName.Domain.Models;
using $projectName.Application.Services;
using $projectName.Domain.Settings;

namespace $projectName.Infrastructure.Services;
public class EmailService : IEmailService
{
    private readonly IMapper _mapper;
    private readonly EmailSettings _emailSettings;
    public EmailService(IMapper mapper, IOptions<EmailSettings> emailSettings)
    {
        _mapper = mapper;
        _emailSettings = emailSettings.Value;
    }

    private async Task send(EmailModel model)
    {
        var email = new MimeMessage();

        email.From.Add(new MailboxAddress(model.FromDisplay, _emailSettings.FromEmail));

        if (!String.IsNullOrEmpty(model.ToEmail))
        {
            string[] emailAddress = model.ToEmail.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string mail in emailAddress)
            {
                email.To.Add(MailboxAddress.Parse(mail.Trim()));
            }
        }
        if (!String.IsNullOrEmpty(model.CcEmail))
        {
            string[] emailAddress = model.CcEmail.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string mail in emailAddress)
            {
                email.Cc.Add(MailboxAddress.Parse(mail.Trim()));
            }
        }
        if (!String.IsNullOrEmpty(model.BccEmail))
        {
            string[] emailAddress = model.BccEmail.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string mail in emailAddress)
            {
                email.Bcc.Add(MailboxAddress.Parse(mail.Trim()));
            }
        }

        // attach file
        var builder = new BodyBuilder();
        builder.HtmlBody = model.Body;
        foreach (var attach in model.Attaches ?? new List<EmailAttach>())
        {
            builder.Attachments.Add(attach.FileName, attach.Data);
        }

        email.Body = builder.ToMessageBody();


        // send email
        using var smtp = new SmtpClient();
        await smtp.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, SecureSocketOptions.Auto);
        await smtp.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPass);
        await smtp.SendAsync(email);
        await smtp.DisconnectAsync(true);
    }

    public async Task SendEmailProductAdd(Guid productId)
    {
        var email = new EmailModel();
        email.FromDisplay = "Auto Email";
        email.ToEmail = "test.001@email.com;test.002@email.com";
        email.Subject = "Product Added (" + productId + ")";
        email.Body = "Product Added (" + productId + ")";
        await send(email);
    }

}

"@
Set-Content -Path "$src\$projectName.Infrastructure\Services\EmailService.cs" -Value $emailService

$addInfrastructure = @"
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using $projectName.Application.Repositories.Common;
using $projectName.Application.Services;
using $projectName.Domain.Settings;
using $projectName.Infrastructure.Data;
using $projectName.Infrastructure.Repositories.Common;
using $projectName.Infrastructure.Services;

namespace $projectName.Infrastructure;

public static class ConfigureServices
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("DefaultConnection");
        services.AddDbContext<AppDbContext>(opt => opt.UseNpgsql(connectionString));

        services.Configure<EmailSettings>(configuration.GetSection("EmailSettings"));

        services.AddScoped<IUnitOfWork, UnitOfWork<AppDbContext>>();

        services.AddTransient<IPaginationService, PaginationService>();
        services.AddTransient<IEmailService, EmailService>();

        return services;
    }
}

"@
Set-Content -Path "$src\$projectName.Infrastructure\ConfigureServices.cs" -Value $addInfrastructure

# Domain ======================================
$baseEntity = @"
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace $projectName.Domain.Entities.Common;

public class BaseEntity
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public Guid Id { get; set; }
    public Guid? CreatedId { get; set; }
    public DateTime? CreatedDate { get; set; }
    public Guid? UpdatedId { get; set; }
    public DateTime? UpdatedDate { get; set; }
}

"@
Set-Content -Path "$src\$projectName.Domain\Entities\Common\BaseEntity.cs" -Value $baseEntity

$masterProduct = @"

using System.ComponentModel.DataAnnotations.Schema;
using $projectName.Domain.Entities.Common;

namespace $projectName.Domain.Entities;

public class MasterProduct : BaseEntity
{
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }

    [ForeignKey(nameof(MasterProductBarcode.ProductId))]
    public virtual IList<MasterProductBarcode> Barcode { get; set; } = null!;
}

"@
Set-Content -Path "$src\$projectName.Domain\Entities\MasterProduct.cs" -Value $masterProduct

$masterProductBarcode = @"
using System.ComponentModel.DataAnnotations.Schema;
using $projectName.Domain.Entities.Common;

namespace $projectName.Domain.Entities;

public class MasterProductBarcode : BaseEntity
{
    [ForeignKey(nameof(MasterProduct))]
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }

}

"@
Set-Content -Path "$src\$projectName.Domain\Entities\MasterProductBarcode.cs" -Value $masterProductBarcode

$pagination = @"

namespace $projectName.Domain.Models;

public class Pagination<T>
{
    public int Total { get; set; }

    public List<T> Results { get; set; } = null!;

}
"@
Set-Content -Path "$src\$projectName.Domain\Models\Pagination.cs" -Value $pagination

$email = @"

namespace $projectName.Domain.Models;

public class EmailModel
{
    public string? FromDisplay { get; set; }
    public string ToEmail { get; set; } = null!;
    public string? CcEmail { get; set; }
    public string? BccEmail { get; set; }
    public string Subject { get; set; } = null!;
    public string Body { get; set; } = null!;
    public IList<EmailAttach>? Attaches { get; set; }
}

public class EmailAttach
{
    public string FileName { get; set; } = null!;
    public byte[] Data { get; set; } = null!;
}
"@
Set-Content -Path "$src\$projectName.Domain\Models\Email.cs" -Value $email

$emailSettings = @"
namespace $projectName.Domain.Settings;

public class EmailSettings
{
    public string FromEmail { get; set; } = null!;
    public string SmtpHost { get; set; } = null!;
    public int SmtpPort { get; set; }
    public string SmtpUser { get; set; } = null!;
    public string SmtpPass { get; set; } = null!;
}
"@
Set-Content -Path "$src\$projectName.Domain\Settings\EmailSettings.cs" -Value $emailSettings

# ======================================

$readme = @"
### Add migrations command
```
dotnet ef migrations add Initial -s src/$projectName.Api -p src/$projectName.Infrastructure
```

### Update database
```
dotnet ef database update -s src/$projectName.Api -p src/$projectName.Infrastructure
```

### Publish project
```
dotnet publish -o publish/yyyymmdd-hhmm-$projectName-api
```

### build and debug in vscode (OmniSharp)
```
ctrl + shift + p => .NET : Generate Assets for Build and Debug 

OmniSharp will generate .vscode

Start Debugging (F5)
```
"@
Set-Content -Path "README.MD" -Value $readme

dotnet restore;
# ======================================
Write-Host "Projects created successfully!"