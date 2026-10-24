using Microsoft.AspNetCore.Mvc;
using nhom5_baitap2_flutter_Tuan10.Models;

namespace nhom5_baitap02_flutter_tuan10.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChuyenNganhController : ControllerBase
    {
        private readonly QuanLyDoAnContext _context;

        public ChuyenNganhController(QuanLyDoAnContext context)
        {
            _context = context;
        }

        [HttpGet]
        public ActionResult GetAll()
        {
            return Ok(_context.ChuyenNganhs.ToList());
        }
    }
}