// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Maps.Map
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace Game.Logic.Phy.Maps
{
  public class Map
  {
    private MapInfo mapInfo_0;
    private float float_0;
    private HashSet<Physics> hashSet_0;
    protected Tile _layer1;
    protected Tile _layer2;
    protected Rectangle _bound;

    public float wind
    {
      get => this.float_0;
      set => this.float_0 = value;
    }

    public float gravity => (float) this.mapInfo_0.Weight;

    public float airResistance => (float) this.mapInfo_0.DragIndex;

    public Tile Ground => this._layer1;

    public MapInfo Info => this.mapInfo_0;

    public Rectangle Bound => this._bound;

    public Map(MapInfo info, Tile layer1, Tile layer2)
    {
      this.mapInfo_0 = info;
      this.hashSet_0 = new HashSet<Physics>();
      this._layer1 = layer1;
      this._layer2 = layer2;
      if (this._layer1 != null)
        this._bound = new Rectangle(0, 0, this._layer1.Width, this._layer1.Height);
      else
        this._bound = new Rectangle(0, 0, this._layer2.Width, this._layer2.Height);
    }

    public void Dig(int cx, int cy, Tile surface, Tile border)
    {
      if (this._layer1 != null)
        this._layer1.Dig(cx, cy, surface, border);
      if (this._layer2 == null)
        return;
      this._layer2.Dig(cx, cy, surface, border);
    }

    public bool IsEmpty(int x, int y)
    {
      return (this._layer1 == null || this._layer1.IsEmpty(x, y)) && (this._layer2 == null || this._layer2.IsEmpty(x, y));
    }

    public bool IsSpecialMap() => this.Info.ID == 1303;

    public bool IsRectangleEmpty(Rectangle rect)
    {
      return (this._layer1 == null || this._layer1.IsRectangleEmptyQuick(rect)) && (this._layer2 == null || this._layer2.IsRectangleEmptyQuick(rect));
    }

    public Point FindYLineNotEmptyPoint(int x, int y, int h)
    {
      x = x < 0 ? 0 : (x >= this._bound.Width ? this._bound.Width - 1 : x);
      y = y < 0 ? 0 : y;
      h = y + h >= this._bound.Height ? this._bound.Height - y - 1 : h;
      for (int index = 0; index < h; ++index)
      {
        if (!this.IsEmpty(x - 1, y) || !this.IsEmpty(x + 1, y))
          return new Point(x, y);
        ++y;
      }
      return Point.Empty;
    }

    public Point FindYLineNotEmptyPoint(int x, int y)
    {
      return this.FindYLineNotEmptyPoint(x, y, this._bound.Height);
    }

    public Point FindNextWalkPoint(int x, int y, int direction, int stepX, int stepY)
    {
      if (direction != 1 && direction != -1)
        return Point.Empty;
      int x1 = x + direction * stepX;
      if (x1 < 0 || x1 > this._bound.Width)
        return Point.Empty;
      Point nextWalkPoint = this.FindYLineNotEmptyPoint(x1, y - stepY - 1, this._bound.Height);
      if (nextWalkPoint != Point.Empty && Math.Abs(nextWalkPoint.Y - y) > stepY)
        nextWalkPoint = Point.Empty;
      return nextWalkPoint;
    }

    public bool canMove(int x, int y) => this.IsEmpty(x, y) && !this.IsOutMap(x, y);

    public bool IsOutMap(int x, int y)
    {
      return x < 0 || x >= this._bound.Width || y >= this._bound.Height;
    }

    public void AddPhysical(Physics phy)
    {
      phy.SetMap(this);
      lock (this.hashSet_0)
        this.hashSet_0.Add(phy);
    }

    public void RemovePhysical(Physics phy)
    {
      phy.SetMap((Map) null);
      lock (this.hashSet_0)
        this.hashSet_0.Remove(phy);
    }

    public List<Physics> GetAllPhysicalSafe()
    {
      List<Physics> allPhysicalSafe = new List<Physics>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
          allPhysicalSafe.Add(physics);
      }
      return allPhysicalSafe;
    }

    public List<PhysicalObj> GetAllPhysicalObjSafe()
    {
      List<PhysicalObj> allPhysicalObjSafe = new List<PhysicalObj>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is PhysicalObj)
            allPhysicalObjSafe.Add(physics as PhysicalObj);
        }
      }
      return allPhysicalObjSafe;
    }

    public Physics[] FindPhysicalObjects(Rectangle rect, Physics except)
    {
      List<Physics> physicsList = new List<Physics>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics.IsLiving && physics != except)
          {
            Rectangle bound = physics.Bound;
            Rectangle bound1 = physics.Bound1;
            bound.Offset(physics.X, physics.Y);
            bound1.Offset(physics.X, physics.Y);
            if (bound.IntersectsWith(rect) || bound1.IntersectsWith(rect))
              physicsList.Add(physics);
          }
        }
      }
      return physicsList.ToArray();
    }

    public bool FindPlayers(Point p, int radius)
    {
      int num = 0;
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Player && physics.IsLiving && (physics as Player).BoundDistance(p) < (double) radius)
            ++num;
          if (num >= 2)
            return true;
        }
      }
      return false;
    }

    public List<Player> FindPlayers(int x, int y, int radius)
    {
      List<Player> players = new List<Player>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Player && physics.IsLiving && physics.Distance(x, y) < (double) radius)
            players.Add(physics as Player);
        }
      }
      return players;
    }

    public List<Living> FindLivings(int x, int y, int radius)
    {
      List<Living> livings = new List<Living>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Living && physics.IsLiving && physics.Distance(x, y) < (double) radius)
            livings.Add(physics as Living);
        }
      }
      return livings;
    }

    public List<Living> FindPlayers(int fx, int tx, List<Player> exceptPlayers)
    {
      List<Living> players = new List<Living>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Player && physics.IsLiving && physics.X > fx && physics.X < tx)
          {
            if (exceptPlayers != null)
            {
              foreach (Player exceptPlayer in exceptPlayers)
              {
                if (((Player) physics).PlayerDetail != exceptPlayer.PlayerDetail)
                  players.Add(physics as Living);
              }
            }
            else
              players.Add(physics as Living);
          }
        }
      }
      return players;
    }

    public List<Living> FindHitByHitPiont()
    {
      List<Living> hitByHitPiont = new List<Living>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Living && physics.IsLiving)
            hitByHitPiont.Add(physics as Living);
        }
      }
      return hitByHitPiont;
    }

    public List<Living> FindHitByHitPiont(Point p, int radius)
    {
      List<Living> hitByHitPiont = new List<Living>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Living && physics.IsLiving && (physics as Living).BoundDistance(p) < (double) radius)
            hitByHitPiont.Add(physics as Living);
        }
      }
      return hitByHitPiont;
    }

    public Living FindNearestEnemy(int x, int y, double maxdistance, Living except)
    {
      Living nearestEnemy = (Living) null;
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Living && physics != except && physics.IsLiving && ((Living) physics).Team != except.Team)
          {
            double num = physics.Distance(x, y);
            if (num < maxdistance)
            {
              nearestEnemy = physics as Living;
              maxdistance = num;
            }
          }
        }
      }
      return nearestEnemy;
    }

    public List<Living> FindAllNearestEnemy(int x, int y, double maxdistance, Living except)
    {
      List<Living> allNearestEnemy = new List<Living>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Living && physics != except && physics.IsLiving && ((Living) physics).Team != except.Team)
          {
            double num = physics.Distance(x, y);
            if (num < maxdistance)
            {
              allNearestEnemy.Add(physics as Living);
              maxdistance = num;
            }
          }
        }
      }
      return allNearestEnemy;
    }

    public List<Living> FindAllNearestSameTeam(int x, int y, double maxdistance, Living except)
    {
      List<Living> allNearestSameTeam = new List<Living>();
      lock (this.hashSet_0)
      {
        foreach (Physics physics in this.hashSet_0)
        {
          if (physics is Living && physics != except && physics.IsLiving && ((Living) physics).Team == except.Team)
          {
            double num = physics.Distance(x, y);
            if (num < maxdistance)
            {
              allNearestSameTeam.Add(physics as Living);
              maxdistance = num;
            }
          }
        }
      }
      return allNearestSameTeam;
    }

    public void Dispose()
    {
      foreach (Physics physics in this.hashSet_0)
        physics.Dispose();
    }

    public Map Clone()
    {
      return new Map(this.mapInfo_0, this._layer1 != null ? this._layer1.Clone() : (Tile) null, this._layer2 != null ? this._layer2.Clone() : (Tile) null);
    }
  }
}
