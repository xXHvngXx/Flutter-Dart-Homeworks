using Microsoft.EntityFrameworkCore;
using nhom5_baitap2_flutter_Tuan10.Models;


var builder = WebApplication.CreateBuilder(args);
// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


// Khai báo Dependencies cho DbContext
builder.Services.AddDbContext<QuanLyDoAnContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("QuanLyDoAn")));

// Khai báo CORS cho phép Flutter gọi API
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Kích hoạt CORS
app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

app.Run();
