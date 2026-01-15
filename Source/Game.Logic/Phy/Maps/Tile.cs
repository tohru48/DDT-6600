// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Maps.Tile
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System;
using System.Drawing;
using System.IO;

#nullable disable
namespace Game.Logic.Phy.Maps
{
  public class Tile
  {
    private byte[] byte_0;
    private int int_0;
    private int int_1;
    private Rectangle rectangle_0;
    private int int_2;
    private int int_3;
    private bool bool_0;

    public Rectangle Bound => this.rectangle_0;

    public byte[] Data => this.byte_0;

    public int Width => this.int_0;

    public int Height => this.int_1;

    public Tile(byte[] data, int width, int height, bool digable)
    {
      this.byte_0 = data;
      this.int_0 = width;
      this.int_1 = height;
      this.bool_0 = digable;
      this.int_2 = this.int_0 / 8 + 1;
      this.int_3 = this.int_1;
      this.rectangle_0 = new Rectangle(0, 0, this.int_0, this.int_1);
      GC.AddMemoryPressure((long) data.Length);
    }

    public Tile(Bitmap bitmap, bool digable)
    {
      this.int_0 = bitmap.Width;
      this.int_1 = bitmap.Height;
      this.int_2 = this.int_0 / 8 + 1;
      this.int_3 = this.int_1;
      this.byte_0 = new byte[this.int_2 * this.int_3];
      this.bool_0 = digable;
      for (int y = 0; y < bitmap.Height; ++y)
      {
        for (int x = 0; x < bitmap.Width; ++x)
        {
          byte num = bitmap.GetPixel(x, y).A <= (byte) 100 ? (byte) 0 : (byte) 1;
          this.byte_0[y * this.int_2 + x / 8] |= (byte) ((uint) num << 7 - x % 8);
        }
      }
      this.rectangle_0 = new Rectangle(0, 0, this.int_0, this.int_1);
      GC.AddMemoryPressure((long) this.byte_0.Length);
    }

    public Tile(string file, bool digable)
    {
      BinaryReader binaryReader = new BinaryReader((Stream) File.Open(file, FileMode.Open));
      this.int_0 = binaryReader.ReadInt32();
      this.int_1 = binaryReader.ReadInt32();
      this.int_2 = this.int_0 / 8 + 1;
      this.int_3 = this.int_1;
      this.byte_0 = binaryReader.ReadBytes(this.int_2 * this.int_3);
      this.bool_0 = digable;
      this.rectangle_0 = new Rectangle(0, 0, this.int_0, this.int_1);
      binaryReader.Close();
      GC.AddMemoryPressure((long) this.byte_0.Length);
    }

    public void Dig(int cx, int cy, Tile surface, Tile border)
    {
      if (!this.bool_0 || surface == null)
        return;
      this.Remove(cx - surface.Width / 2, cy - surface.Height / 2, surface);
      if (border != null)
        this.Add(cx - border.Width / 2, cy - border.Height / 2, surface);
    }

    protected void Add(int x, int y, Tile tile)
    {
    }

    protected void Remove(int x, int y, Tile tile)
    {
      byte[] byte0 = tile.byte_0;
      Rectangle bound = tile.Bound;
      bound.Offset(x, y);
      bound.Intersect(this.rectangle_0);
      if (bound.Width == 0 || bound.Height == 0)
        return;
      bound.Offset(-x, -y);
      int num1 = bound.X / 8;
      int num2 = (bound.X + x) / 8;
      int y1 = bound.Y;
      int num3 = bound.Width / 8 + 1;
      int height = bound.Height;
      if (bound.X == 0)
      {
        if (num3 + num2 < this.int_2)
        {
          int num4 = num3 + 1;
          num3 = num4 > tile.int_2 ? tile.int_2 : num4;
        }
        int num5 = (bound.X + x) % 8;
        for (int index1 = 0; index1 < height; ++index1)
        {
          int num6 = 0;
          for (int index2 = 0; index2 < num3; ++index2)
          {
            int index3 = (index1 + y + y1) * this.int_2 + index2 + num2;
            int index4 = (index1 + y1) * tile.int_2 + index2 + num1;
            int num7 = (int) byte0[index4];
            int num8 = num7 >> num5;
            int num9 = (int) this.byte_0[index3];
            int num10 = num9 & ~(num9 & num8);
            if (num6 != 0)
              num10 &= ~(num10 & num6);
            this.byte_0[index3] = (byte) num10;
            num6 = num7 << 8 - num5;
          }
        }
      }
      else
      {
        int num11 = bound.X % 8;
        for (int index5 = 0; index5 < height; ++index5)
        {
          for (int index6 = 0; index6 < num3; ++index6)
          {
            int index7 = (index5 + y + y1) * this.int_2 + index6 + num2;
            int index8 = (index5 + y1) * tile.int_2 + index6 + num1;
            int num12 = (int) byte0[index8] << num11;
            int num13 = index6 >= num3 - 1 ? 0 : (int) byte0[index8 + 1] >> 8 - num11;
            int num14 = (int) this.byte_0[index7];
            int num15 = num14 & ~(num14 & num12);
            if (num13 != 0)
              num15 &= ~(num15 & num13);
            this.byte_0[index7] = (byte) num15;
          }
        }
      }
    }

    public bool IsEmpty(int x, int y)
    {
      if (x < 0 || x >= this.int_0 || y < 0 || y >= this.int_1)
        return true;
      byte num = (byte) (1 << 7 - x % 8);
      return ((int) this.byte_0[y * this.int_2 + x / 8] & (int) num) == 0;
    }

    public bool IsYLineEmtpy(int x, int y, int h)
    {
      if (x < 0 || x >= this.int_0)
        return true;
      y = y < 0 ? 0 : y;
      h = y + h > this.int_1 ? this.int_1 - y : h;
      for (int index = 0; index < h; ++index)
      {
        if (!this.IsEmpty(x, y + index))
          return false;
      }
      return true;
    }

    public bool IsRectangleEmptyQuick(Rectangle rect)
    {
      rect.Intersect(this.rectangle_0);
      return this.IsEmpty(rect.Right, rect.Bottom) && this.IsEmpty(rect.Left, rect.Bottom) && this.IsEmpty(rect.Right, rect.Top) && this.IsEmpty(rect.Left, rect.Top);
    }

    public Point FindNotEmptyPoint(int x, int y, int h)
    {
      if (x < 0 || x >= this.int_0)
        return new Point(-1, -1);
      y = y < 0 ? 0 : y;
      h = y + h > this.int_1 ? this.int_1 - y : h;
      for (int index = 0; index < h; ++index)
      {
        if (!this.IsEmpty(x, y + index))
          return new Point(x, y + index);
      }
      return new Point(-1, -1);
    }

    public Bitmap ToBitmap()
    {
      Bitmap bitmap = new Bitmap(this.int_0, this.int_1);
      for (int y = 0; y < this.int_1; ++y)
      {
        for (int x = 0; x < this.int_0; ++x)
        {
          if (this.IsEmpty(x, y))
            bitmap.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
          else
            bitmap.SetPixel(x, y, Color.FromArgb((int) byte.MaxValue, 0, 0, 0));
        }
      }
      return bitmap;
    }

    public Tile Clone()
    {
      return new Tile(this.byte_0.Clone() as byte[], this.int_0, this.int_1, this.bool_0);
    }
  }
}
