using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using moo.Domain.Entities;

namespace moo.Infrastructure.Data.Configurations;
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