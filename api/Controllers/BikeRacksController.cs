using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using CsvHelper;

namespace api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BikeRacksController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            var racks = new List<dynamic>();

            using (var reader = new StreamReader("Data/bike_racks.csv"))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                foreach (var record in csv.GetRecords<dynamic>())
                {
                    racks.Add(new {
                        id = record.INV_ID,
                        longitude = record.LONG,
                        latitude = record.LAT,
                        park = record.PARC,
                        territory = record.TERRITOIRE
                    });
                }
            }

            return Ok(racks);
        }
    }
}
