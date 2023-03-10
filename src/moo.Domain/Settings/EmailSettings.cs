namespace moo.Domain.Settings;

public class EmailSettings
{
    public string FromEmail { get; set; } = null!;
    public string SmtpHost { get; set; } = null!;
    public int SmtpPort { get; set; }
    public string SmtpUser { get; set; } = null!;
    public string SmtpPass { get; set; } = null!;
}