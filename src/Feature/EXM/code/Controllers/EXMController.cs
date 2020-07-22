using ExmExample.Feature.EXM.Models;
using Glass.Mapper.Sc.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace ExmExample.Feature.EXM.Controllers
{
    public class ExmController : Controller
    {
        private readonly IMvcContext _context;
        public ExmController()
        {
            _context = new MvcContext();
        }

        public ActionResult RenderBanner()
        {
            IBanner model = _context.GetDataSourceItem<IBanner>();

            return View(model);
        }
    }
}