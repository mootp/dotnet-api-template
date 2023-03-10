using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moo.Domain.Entities.Common;

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
