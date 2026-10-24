using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace nhom5_baitap2_flutter_Tuan10.Models;

public partial class QuanLyDoAnContext : DbContext
{
    public QuanLyDoAnContext()
    {
    }

    public QuanLyDoAnContext(DbContextOptions<QuanLyDoAnContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ChuyenNganh> ChuyenNganhs { get; set; }

    public virtual DbSet<LoaiDeTai> LoaiDeTais { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ChuyenNganh>(entity =>
        {
            entity.HasKey(e => e.MaCn).HasName("PK__ChuyenNg__27258E0E03317E3D");

            entity.ToTable("ChuyenNganh");

            entity.Property(e => e.MaCn)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("MaCN");
            entity.Property(e => e.MoTa).HasMaxLength(255);
            entity.Property(e => e.TenCn)
                .HasMaxLength(100)
                .HasColumnName("TenCN");
        });

        modelBuilder.Entity<LoaiDeTai>(entity =>
        {
            entity.HasKey(e => e.MaLoai).HasName("PK__LoaiDeTa__730A57597F60ED59");

            entity.ToTable("LoaiDeTai");

            entity.Property(e => e.MaLoai)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.TenLoai).HasMaxLength(50);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
