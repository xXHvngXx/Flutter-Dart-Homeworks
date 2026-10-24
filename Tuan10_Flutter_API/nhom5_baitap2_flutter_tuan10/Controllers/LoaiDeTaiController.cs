using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using nhom5_baitap2_flutter_Tuan10.Models;

namespace nhom5_baitap2_flutter_Tuan10.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoaiDeTaiController : ControllerBase
    {
        private readonly QuanLyDoAnContext _context;

        public LoaiDeTaiController(QuanLyDoAnContext context)
        {
            _context = context;
        }

        [HttpGet]
        public ActionResult GetAll()
        {
            return Ok(_context.LoaiDeTais.ToList());
        }
    }
}
