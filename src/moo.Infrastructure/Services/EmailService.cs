using AutoMapper;
using MimeKit;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using moo.Application.Services;
using moo.Domain.Settings;
using moo.Application.Common.Models;

namespace moo.Infrastructure.Services;
public class EmailService : IEmailService
{
    private readonly IMapper _mapper;
    private readonly EmailSettings _emailSettings;
    public EmailService(IMapper mapper, IOptions<EmailSettings> emailSettings)
    {
        _mapper = mapper;
        _emailSettings = emailSettings.Value;
    }

    public async Task Send(EmailModel model)
    {
        var email = new MimeMessage();

        email.From.Add(new MailboxAddress(model.FromDisplay, _emailSettings.FromEmail));

        if (!String.IsNullOrEmpty(model.ToEmail))
        {
            string[] emailAddress = model.ToEmail.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string mail in emailAddress)
            {
                email.To.Add(MailboxAddress.Parse(mail.Trim()));
            }
        }
        if (!String.IsNullOrEmpty(model.CcEmail))
        {
            string[] emailAddress = model.CcEmail.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string mail in emailAddress)
            {
                email.Cc.Add(MailboxAddress.Parse(mail.Trim()));
            }
        }
        if (!String.IsNullOrEmpty(model.BccEmail))
        {
            string[] emailAddress = model.BccEmail.Split(new Char[] { ',', ';', '|', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string mail in emailAddress)
            {
                email.Bcc.Add(MailboxAddress.Parse(mail.Trim()));
            }
        }

        // attach file
        var builder = new BodyBuilder();
        builder.HtmlBody = model.Body;
        foreach (var attach in model.Attaches ?? new List<EmailAttach>())
        {
            builder.Attachments.Add(attach.FileName, attach.Data);
        }

        email.Body = builder.ToMessageBody();

        // send email
        using var smtp = new SmtpClient();
        await smtp.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, SecureSocketOptions.Auto);
        await smtp.AuthenticateAsync(_emailSettings.SmtpUser, _emailSettings.SmtpPass);
        await smtp.SendAsync(email);
        await smtp.DisconnectAsync(true);
    }

    public async Task SendEmailProductAdd(Guid productId)
    {
        var email = new EmailModel();
        email.FromDisplay = "Auto Email";
        email.ToEmail = "test.001@email.com;test.002@email.com";
        email.Subject = "Product Added (" + productId + ")";
        email.Body = "Product Added (" + productId + ")";
        await Send(email);
    }

}
