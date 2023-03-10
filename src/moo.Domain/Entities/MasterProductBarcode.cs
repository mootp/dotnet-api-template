using System.ComponentModel.DataAnnotations.Schema;
using moo.Domain.Entities.Common;

namespace moo.Domain.Entities;

public class MasterProductBarcode : BaseEntity
{
    [ForeignKey(nameof(MasterProduct))]
    public Guid ProductId { get; set; }
    public string Barcode { get; set; } = null!;
    public string? Desc { get; set; }

}
