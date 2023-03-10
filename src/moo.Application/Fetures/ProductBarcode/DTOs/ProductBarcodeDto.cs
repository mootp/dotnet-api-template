using AutoMapper;
using moo.Application.Common.Mappings;
using moo.Application.Fetures.ProductBarcode.Commands;
using moo.Domain.Entities;

namespace moo.Application.Fetures.ProductBarcode.DTOs;

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
