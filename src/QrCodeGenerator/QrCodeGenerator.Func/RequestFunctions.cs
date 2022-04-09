using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using QRCoder;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace QrCodeGenerator.Func
{
    public class RequestFunctions
    {
        #region Fields
        private IConfiguration _configuration;
        #endregion

        #region Ctor
        public RequestFunctions(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        #endregion

        #region APIs

        [FunctionName("GetQrCode")]
        public IActionResult GetQrCode(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "qrcode/{payload}")] HttpRequest req,
            string payload,
            ILogger log)
        {
            log.LogInformation("New retrieve request arrived");

            if (!ValidateInput(payload))
            {
               return new BadRequestObjectResult(new { Error = "Invalid or empty id." });
            }

            var validateUrl = $"{payload}";
            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCodeData = qrGenerator.CreateQrCode(validateUrl, QRCodeGenerator.ECCLevel.H);
            QRCode qrCode = new QRCode(qrCodeData);

            using (Bitmap qrCodeImage = qrCode.GetGraphic(10))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    qrCodeImage.Save(ms, ImageFormat.Png);
                    req.HttpContext.Response.Headers.Append("Cache-Control", "public, max-age=86400");
                    return new FileContentResult(ms.ToArray(), "image/png");
                }
            }
        }

        #endregion

        private bool ValidateInput(string qrPayload) 
        {
            return !string.IsNullOrWhiteSpace(qrPayload);
        }
    }
}
