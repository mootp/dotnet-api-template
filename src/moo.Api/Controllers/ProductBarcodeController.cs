using Microsoft.AspNetCore.Mvc;
using moo.Api.Controllers.Common;
using moo.Application.Common.Models;
using moo.Application.Fetures.ProductBarcode.Commands;
using moo.Application.Fetures.ProductBarcode.Queries;
using moo.Application.Fetures.ProductBarcode.DTOs;

namespace moo.Api.Controllers;

public class ProductBarcodeController : BaseApiController
{
    [HttpGet("[action]")]
    public async Task<ActionResult<Pagination<ProductBarcodeDto>>> ProductBarcodeList([FromQuery] ProductBarcodeWithPaginationQuery query)
    {
        return await Mediator.Send(query);
    }

    [HttpGet("[action]/{id}")]
    public async Task<ActionResult<ProductBarcodeDto>> ProductBarcodeDetail(Guid id)
    {
        var query = new ProductBarcodeDetailQuery { Id = id };
        return await Mediator.Send(query);
    }

    [HttpPost("[action]")]
    public async Task<ActionResult<Guid>> ProductBarcodeCreate(ProductBarcodeCreateCommand command)
    {
        return await Mediator.Send(command);
    }

    [HttpPut("[action]/{id}")]
    public async Task<ActionResult> ProductBarcodeUpdate(Guid id, ProductBarcodeUpdateCommand command)
    {
        if (id != command.Id)
        {
            return BadRequest();
        }

        await Mediator.Send(command);

        return NoContent();
    }

    [HttpDelete("[action]/{id}")]
    public async Task<ActionResult> ProductBarcodeDelete(Guid id)
    {
        await Mediator.Send(new ProductBarcodeDeleteCommand { Id = id });

        return NoContent();
    }

}
