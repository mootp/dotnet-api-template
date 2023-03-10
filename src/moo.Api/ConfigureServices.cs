
using moo.Infrastructure.Data;

namespace moo.Api;

public static class ConfigureServices
{
    public static IServiceCollection AddApi(this IServiceCollection services)
    {
        services.AddHttpContextAccessor();
        services.AddHealthChecks().AddDbContextCheck<AppDbContext>();

        return services;
    }
}
