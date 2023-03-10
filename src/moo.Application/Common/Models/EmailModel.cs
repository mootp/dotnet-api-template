
namespace moo.Application.Common.Models;
public class EmailModel
{
    public string? FromDisplay { get; set; }
    public string ToEmail { get; set; } = null!;
    public string? CcEmail { get; set; }
    public string? BccEmail { get; set; }
    public string Subject { get; set; } = null!;
    public string Body { get; set; } = null!;
    public IList<EmailAttach>? Attaches { get; set; }
}

public class EmailAttach
{
    public string FileName { get; set; } = null!;
    public byte[] Data { get; set; } = null!;
}