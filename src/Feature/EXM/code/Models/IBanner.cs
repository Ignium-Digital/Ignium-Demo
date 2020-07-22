using Glass.Mapper.Sc.Fields;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ExmExample.Feature.EXM.Models
{
    public interface IBanner
    {
        Link CTA { get; set; }

        Image Banner { get; set; }
    }
}