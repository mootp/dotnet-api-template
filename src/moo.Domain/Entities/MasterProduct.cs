
using System.ComponentModel.DataAnnotations.Schema;
using moo.Domain.Entities.Common;

namespace moo.Domain.Entities;

public class MasterProduct : BaseEntity
{
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public string? Desc { get; set; }

    [ForeignKey(nameof(MasterProductBarcode.ProductId))]
    public virtual IList<MasterProductBarcode> Barcode { get; set; } = null!;
}
