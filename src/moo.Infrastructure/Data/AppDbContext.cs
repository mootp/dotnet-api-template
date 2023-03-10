using Microsoft.EntityFrameworkCore;
using moo.Domain.Entities;
using moo.Infrastructure.Data.Configurations;

namespace moo.Infrastructure.Data;

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
