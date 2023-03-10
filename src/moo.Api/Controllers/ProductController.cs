using Microsoft.AspNetCore.Mvc;
using moo.Api.Controllers.Common;
using moo.Application.Fetures.Product.Commands;
using moo.Application.Fetures.Product.Queries;
using moo.Application.Fetures.Product.DTOs;
using moo.Application.Notifications;
using moo.Application.Common.Models;


namespace moo.Api.Controllers;

public class ProductController : BaseApiController
{
    [HttpGet("[action]")]
    public async Task<ActionResult<Pagination<ProductDto>>> ProductList([FromQuery] ProductWithPaginationQuery query)
    {
        return await Mediator.Send(query);
    }

    [HttpGet("[action]/{id}")]
    public async Task<ActionResult<ProductDto>> ProductDetail(Guid id)
    {
        var query = new ProductDetailQuery { Id = id };
        return await Mediator.Send(query);
    }

    [HttpPost("[action]")]
    public async Task<ActionResult<Guid>> ProductCreate(ProductCreateCommand command)
    {
        var id = await Mediator.Send(command);
        await Mediator.Publish(new ProductCreateNotification { productId = id });
        return id;
    }

    [HttpPut("[action]/{id}")]
    public async Task<ActionResult> ProductUpdate(Guid id, ProductUpdateCommand command)
    {
        if (id != command.Id)
        {
            return BadRequest();
        }

        await Mediator.Send(command);

        return NoContent();
    }

    [HttpDelete("[action]/{id}")]
    public async Task<ActionResult> ProductDelete(Guid id)
    {
        await Mediator.Send(new ProductDeleteCommand { Id = id });

        return NoContent();
    }

}
