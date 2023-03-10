
namespace moo.Application.Common.Models;

public class Pagination<T>
{
    public int Total { get; set; }

    public List<T> Results { get; set; } = null!;

}
