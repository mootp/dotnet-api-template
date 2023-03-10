using AutoMapper;
using moo.Application.Common.Mappings;
using moo.Application.Fetures.Product.Commands;
using moo.Application.Fetures.ProductBarcode.DTOs;
using moo.Domain.Entities;

namespace moo.Application.Fetures.Product.DTOs;

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
