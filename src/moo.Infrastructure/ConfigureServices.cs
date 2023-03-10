using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using moo.Application.Repositories.Common;
using moo.Application.Services;
using moo.Domain.Settings;
using moo.Infrastructure.Data;
using moo.Infrastructure.Repositories.Common;
using moo.Infrastructure.Services;

namespace moo.Infrastructure;

public static class ConfigureServices
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("DefaultConnection");
        services.AddDbContext<AppDbContext>(opt => opt.UseNpgsql(connectionString));

        var emailSettings = configuration.GetSection("EmailSettings");

        services.Configure<EmailSettings>(configuration.GetSection("EmailSettings"));

        services.AddScoped<IUnitOfWork, UnitOfWork<AppDbContext>>();

        services.AddTransient<IEmailService, EmailService>();

        return services;
    }
}
