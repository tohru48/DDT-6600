// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.BombObject
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Maths;
using System;
using System.Drawing;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class BombObject : Physics
  {
    private float float_0;
    private float float_1;
    private float float_2;
    private float float_3;
    private EulerVector eulerVector_0;
    private EulerVector eulerVector_1;
    private float float_4;
    private float float_5;
    private float float_6;

    public float vX => this.eulerVector_0.x1;

    public float vY => this.eulerVector_1.x1;

    public float Arf => this.float_4;

    public float Gf => this.float_5;

    public float Wf => this.float_6;

    public BombObject(
      int id,
      float mass,
      float gravityFactor,
      float windFactor,
      float airResitFactor)
      : base(id)
    {
      this.float_0 = mass;
      this.float_1 = gravityFactor;
      this.float_2 = windFactor;
      this.float_3 = airResitFactor;
      this.eulerVector_0 = new EulerVector(0, 0, 0.0f);
      this.eulerVector_1 = new EulerVector(0, 0, 0.0f);
      this.m_rect = new Rectangle(-3, -3, 6, 6);
    }

    public void setSpeedXY(int vx, int vy)
    {
      this.eulerVector_0.x1 = (float) vx;
      this.eulerVector_1.x1 = (float) vy;
    }

    public override void SetXY(int x, int y)
    {
      base.SetXY(x, y);
      this.eulerVector_0.x0 = (float) x;
      this.eulerVector_1.x0 = (float) y;
    }

    public override void SetMap(Map map)
    {
      base.SetMap(map);
      this.method_0();
    }

    protected void UpdateForceFactor(float air, float gravity, float wind)
    {
      this.float_3 = air;
      this.float_1 = gravity;
      this.float_2 = wind;
      this.method_0();
    }

    private void method_0()
    {
      if (this.m_map == null)
        return;
      this.float_4 = this.m_map.airResistance * this.float_3;
      this.float_5 = this.m_map.gravity * this.float_1 * this.float_0;
      this.float_6 = this.m_map.wind * this.float_2;
    }

    protected Point CompleteNextMovePoint(float dt)
    {
      this.eulerVector_0.ComputeOneEulerStep(this.float_0, this.float_4, this.float_6, dt);
      this.eulerVector_1.ComputeOneEulerStep(this.float_0, this.float_4, this.float_5, dt);
      return new Point((int) this.eulerVector_0.x0, (int) this.eulerVector_1.x0);
    }

    public void MoveTo(int px, int py)
    {
      if (px == this.m_x && py == this.m_y)
        return;
      int num1 = px - this.m_x;
      int num2 = py - this.m_y;
      bool flag;
      int num3;
      int num4;
      if (Math.Abs(num1) > Math.Abs(num2))
      {
        flag = true;
        num3 = Math.Abs(num1);
        num4 = num1 / num3;
      }
      else
      {
        flag = false;
        num3 = Math.Abs(num2);
        num4 = num2 / num3;
      }
      Point point = new Point(this.m_x, this.m_y);
      for (int index = 1; index <= num3; index += 3)
      {
        point = !flag ? this.method_2(this.m_x, px, this.m_y, py, this.m_y + index * num4) : this.method_1(this.m_x, px, this.m_y, py, this.m_x + index * num4);
        Rectangle rect = this.m_rect;
        rect.Offset(point.X, point.Y);
        Physics[] physicalObjects = this.m_map.FindPhysicalObjects(rect, (Physics) this);
        if (physicalObjects.Length > 0)
        {
          base.SetXY(point.X, point.Y);
          this.CollideObjects(physicalObjects);
        }
        else if (!this.m_map.IsRectangleEmpty(rect))
        {
          base.SetXY(point.X, point.Y);
          this.CollideGround();
        }
        else if (this.m_map.IsOutMap(point.X, point.Y))
        {
          base.SetXY(point.X, point.Y);
          this.FlyoutMap();
        }
        if (!this.m_isLiving || !this.m_isMoving)
          return;
      }
      base.SetXY(px, py);
    }

    protected virtual void CollideObjects(Physics[] list)
    {
    }

    protected virtual void CollideGround() => this.StopMoving();

    protected virtual void FlyoutMap()
    {
      this.StopMoving();
      if (!this.m_isLiving)
        return;
      this.Die();
    }

    private Point method_1(int int_0, int int_1, int int_2, int int_3, int int_4)
    {
      return int_1 == int_0 ? new Point(int_4, int_2) : new Point(int_4, (int_4 - int_0) * (int_3 - int_2) / (int_1 - int_0) + int_2);
    }

    private Point method_2(int int_0, int int_1, int int_2, int int_3, int int_4)
    {
      return int_3 == int_2 ? new Point(int_0, int_4) : new Point((int_4 - int_2) * (int_1 - int_0) / (int_3 - int_2) + int_0, int_4);
    }
  }
}
