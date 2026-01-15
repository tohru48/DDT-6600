// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.SimpleBomb
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Actions;
using Game.Logic.Effects;
using Game.Logic.Phy.Actions;
using Game.Logic.Phy.Maps;
using Game.Logic.Phy.Maths;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class SimpleBomb : BombObject
  {
    private Living living_0;
    private BaseGame baseGame_0;
    protected Tile m_shape;
    protected int m_radius;
    protected int m_petRadius;
    protected double m_power;
    protected List<BombAction> m_actions;
    protected List<BombAction> m_petActions;
    protected BombType m_type;
    protected bool m_controled;
    private float float_7;
    private BallInfo ballInfo_0;
    private bool bool_0;
    private bool bool_1;

    public bool DigMap => this.bool_1;

    public BallInfo BallInfo => this.ballInfo_0;

    public Living Owner => this.living_0;

    public List<BombAction> PetActions => this.m_petActions;

    public List<BombAction> Actions => this.m_actions;

    public float LifeTime => this.float_7;

    public SimpleBomb(
      int id,
      BombType type,
      Living owner,
      BaseGame game,
      BallInfo info,
      Tile shape,
      bool controled)
      : base(id, (float) info.Mass, (float) info.Weight, (float) info.Wind, (float) info.DragIndex)
    {
      this.living_0 = owner;
      this.baseGame_0 = game;
      this.ballInfo_0 = info;
      this.m_shape = shape;
      this.m_type = type;
      this.m_power = info.Power;
      this.m_radius = info.Radii;
      this.m_controled = controled;
      this.bool_0 = false;
      this.m_petRadius = 80;
      this.float_7 = 0.0f;
      if (this.ballInfo_0.IsSpecial())
        this.bool_1 = false;
      else
        this.bool_1 = true;
    }

    public override void StartMoving()
    {
      base.StartMoving();
      this.m_actions = new List<BombAction>();
      this.m_petActions = new List<BombAction>();
      int lifeTime = this.baseGame_0.LifeTime;
      while (this.m_isMoving && this.m_isLiving)
      {
        this.float_7 += 0.04f;
        Point point1 = this.CompleteNextMovePoint(0.04f);
        this.MoveTo(point1.X, point1.Y);
        if (this.m_isLiving)
        {
          if (Math.Round((double) this.float_7 * 100.0) % 40.0 == 0.0 && point1.Y > 0)
            this.baseGame_0.AddTempPoint(point1.X, point1.Y);
          if (this.m_controled && (double) this.vY > 0.0)
          {
            Living nearestEnemy = this.m_map.FindNearestEnemy(this.m_x, this.m_y, 150.0, this.living_0);
            if (nearestEnemy != null)
            {
              Point point2;
              if (nearestEnemy is SimpleBoss)
              {
                Rectangle directDemageRect = nearestEnemy.GetDirectDemageRect();
                point2 = new Point(directDemageRect.X - this.m_x, directDemageRect.Y - this.m_y);
              }
              else
                point2 = new Point(nearestEnemy.X - this.m_x, nearestEnemy.Y - this.m_y);
              point2 = point2.Normalize(1000);
              this.setSpeedXY(point2.X, point2.Y);
              this.UpdateForceFactor(0.0f, 0.0f, 0.0f);
              this.m_controled = false;
              this.m_actions.Add(new BombAction(this.float_7, ActionType.CHANGE_SPEED, point2.X, point2.Y, 0, 0));
            }
          }
        }
        if (this.bool_0)
        {
          this.bool_0 = false;
          this.method_3();
        }
      }
    }

    protected override void CollideObjects(Physics[] list)
    {
      for (int index = 0; index < list.Length; ++index)
      {
        Physics physics = list[index];
        physics.CollidedByObject((Physics) this);
        this.m_actions.Add(new BombAction(this.float_7, ActionType.PICK, physics.Id, 0, 0, 0));
      }
    }

    protected override void CollideGround()
    {
      base.CollideGround();
      this.Bomb();
    }

    public void Bomb()
    {
      this.StopMoving();
      this.m_isLiving = false;
      this.bool_0 = true;
      this.living_0.Game.method_6(this.living_0, 0);
    }

    private void method_3()
    {
      Point collidePoint = this.GetCollidePoint();
      List<Living> hitByHitPiont = this.m_map.FindHitByHitPiont(collidePoint, this.m_radius);
      foreach (Living living in hitByHitPiont)
      {
        if (living.IsNoHole || living.NoHoleTurn)
        {
          living.NoHoleTurn = true;
          if (!this.ballInfo_0.IsSpecial())
            this.bool_1 = false;
        }
        living.SyncAtTime = false;
      }
      this.living_0.SyncAtTime = false;
      this.living_0.LastPoint = collidePoint;
      try
      {
        if (this.bool_1)
          this.m_map.Dig(this.m_x, this.m_y, this.m_shape, (Tile) null);
        this.m_actions.Add(new BombAction(this.float_7, ActionType.BOMB, this.m_x, this.m_y, this.bool_1 ? 1 : 0, 0));
        switch (this.m_type)
        {
          case BombType.FORZEN:
            using (List<Living>.Enumerator enumerator = hitByHitPiont.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                Living current = enumerator.Current;
                if (this.living_0 is SimpleBoss && new IceFronzeEffect(100).Start(current))
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.FORZEN, current.Id, 0, 0, 0));
                else if (current is SimpleNpc && current.Config.CanFrost)
                {
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.DO_ACTION, current.Id, 0, 0, 4));
                  current.IsFrost = true;
                }
                else if (new IceFronzeEffect(2).Start(current))
                {
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.FORZEN, current.Id, 0, 0, 0));
                }
                else
                {
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.FORZEN, -1, 0, 0, 0));
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.CHANGE_STATE, current.Id, 0, 0, 0));
                }
              }
              break;
            }
          case BombType.FLY:
            if (this.m_y > 10 && (double) this.float_7 > 0.039999999105930328)
            {
              if (!this.m_map.IsEmpty(this.m_x, this.m_y))
              {
                PointF pointF = new PointF(-this.vX, -this.vY).Normalize(5f);
                this.m_x -= (int) pointF.X;
                this.m_y -= (int) pointF.Y;
              }
              this.living_0.SetXY(this.m_x, this.m_y);
              this.living_0.StartFalling(true);
              this.m_actions.Add(new BombAction(this.float_7, ActionType.TRANSLATE, this.m_x, this.m_y, 0, 0));
              this.m_actions.Add(new BombAction(this.float_7, ActionType.START_MOVE, this.living_0.Id, this.living_0.X, this.living_0.Y, this.living_0.IsLiving ? 1 : 0));
              using (List<Living>.Enumerator enumerator = hitByHitPiont.GetEnumerator())
              {
                while (enumerator.MoveNext())
                {
                  Living current = enumerator.Current;
                  if (current is SimpleNpc && current.Config.IsHelper && collidePoint.X < current.X + 25 && collidePoint.X > current.X - 25)
                    this.m_actions.Add(new BombAction(this.float_7, ActionType.WORLDCUP, this.living_0.Id, 0, 0, 0));
                }
                break;
              }
            }
            else
              break;
          case BombType.CURE:
            using (List<Living>.Enumerator enumerator = hitByHitPiont.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                Living current = enumerator.Current;
                double num = !this.m_map.FindPlayers(this.GetCollidePoint(), this.m_radius) ? 1.0 : 0.4;
                int para3 = this.ballInfo_0.ID != 10009 ? (int) ((double) ((Player) this.living_0).PlayerDetail.SecondWeapon.Template.Property7 * Math.Pow(1.1, (double) ((Player) this.living_0).PlayerDetail.SecondWeapon.StrengthenLevel) * num) + this.living_0.FightBuffers.ConsortionAddBloodGunCount + this.living_0.PetEffects.BonusPoint : (int) ((double) this.float_7 * 2000.0);
                if (current is Player)
                {
                  current.AddBlood(para3);
                  ((Player) current).TotalCure += para3;
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.CURE, current.Id, current.Blood, para3, 0));
                }
                if ((current is SimpleBoss || current is SimpleNpc) && current.Config.IsHelper)
                {
                  current.AddBlood(para3);
                  ((SimpleBoss) current).TotalCure += para3;
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.CURE, current.Id, current.Blood, para3, 0));
                }
              }
              break;
            }
          case BombType.WORLDCUP:
            switch (this.ballInfo_0.ID)
            {
              case 110:
                bool flag = false;
                foreach (Living living in hitByHitPiont)
                {
                  if (!(living is SimpleNpc) || !living.Config.IsGoal)
                  {
                    if (living is Player && ((PVEGame) this.baseGame_0).PassBallActive)
                    {
                      this.m_actions.Add(new BombAction(this.float_7, ActionType.WORLDCUP, living.Id, 0, 0, 0));
                      flag = true;
                      break;
                    }
                  }
                  else
                  {
                    ((PVEGame) this.baseGame_0).IsGoal = true;
                    this.m_actions.Add(new BombAction(this.float_7, ActionType.KILL_PLAYER, living.Id, 0, 0, living.Blood));
                    flag = true;
                    break;
                  }
                }
                if (!flag)
                {
                  this.m_actions.Add(new BombAction(this.float_7, ActionType.WORLDCUP, 0, collidePoint.X, collidePoint.X, 0));
                  break;
                }
                break;
              case 117:
                using (List<Living>.Enumerator enumerator = hitByHitPiont.GetEnumerator())
                {
                  while (enumerator.MoveNext())
                  {
                    Living current = enumerator.Current;
                    int para3 = (int) (30.0 * (!this.m_map.FindPlayers(this.GetCollidePoint(), this.m_radius) ? 1.0 : 0.3));
                    if (current is Player)
                    {
                      this.m_actions.Add(new BombAction(this.float_7, ActionType.CURE, current.Id, current.Blood, para3, 0));
                      ((Player) current).TotalCureEnergy += para3;
                      current.AddRemoveEnergy(para3);
                    }
                  }
                  break;
                }
            }
            break;
          case BombType.CATCHINSECT:
            switch (this.ballInfo_0.ID)
            {
              case 128:
                using (List<Living>.Enumerator enumerator = hitByHitPiont.GetEnumerator())
                {
                  while (enumerator.MoveNext())
                  {
                    Living current = enumerator.Current;
                    if (current is SimpleBoss && current.Config.IsInsectBoss)
                      (this.baseGame_0 as PVEGame).method_70();
                  }
                  break;
                }
              case 129:
                int num1 = 0;
                int num2 = 0;
                int num3 = 0;
                int num4 = 0;
                string str1 = "";
                string str2 = "";
                string str3 = "";
                int num5 = (int) ((double) this.float_7 * 2500.0);
                foreach (Living living in hitByHitPiont)
                {
                  if (living is SimpleNpc)
                  {
                    switch ((living as SimpleNpc).NpcInfo.ID)
                    {
                      case 71006:
                        ++num1;
                        ++num2;
                        str1 = (living as SimpleNpc).NpcInfo.Name;
                        (living as SimpleNpc).PlayMovie("dieB", num5, num5);
                        break;
                      case 71007:
                        num1 += 2;
                        ++num3;
                        str2 = (living as SimpleNpc).NpcInfo.Name;
                        (living as SimpleNpc).PlayMovie("dieA", num5, num5);
                        break;
                      case 71008:
                        num1 += 3;
                        ++num4;
                        str3 = (living as SimpleNpc).NpcInfo.Name;
                        (living as SimpleNpc).PlayMovie("dieB", num5, num5);
                        break;
                    }
                    living.Die();
                  }
                }
                if (this.living_0 is Player)
                {
                  string msg = LanguageMgr.GetTranslation("CatchInsect.AddSmallScore") + " ";
                  if (num2 > 0)
                    msg = msg + num2.ToString() + " " + str1 + " ";
                  if (num3 > 0)
                    msg = msg + num3.ToString() + " " + str2 + " ";
                  if (num4 > 0)
                    msg = msg + num4.ToString() + " " + str3 + " ";
                  if (num2 + num3 + num4 > 0)
                    (this.living_0 as Player).PlayerDetail.SendMessage(msg);
                  (this.living_0 as Player).PlayerDetail.AddSummerScore(num1);
                  break;
                }
                break;
            }
            break;
          default:
            foreach (Living living in hitByHitPiont)
            {
              if (!this.living_0.IsFriendly(living) && !living.Config.IsDown)
              {
                if (this.living_0.ClearBuff)
                {
                  living.EffectList.StopAllEffect();
                }
                else
                {
                  int num6;
                  switch (living)
                  {
                    case SimpleBoss _:
                    case SimpleNpc _:
                      num6 = living.Config.IsShield ? 1 : (living.Config.IsGoal ? 1 : 0);
                      break;
                    default:
                      num6 = 0;
                      break;
                  }
                  if (num6 == 0)
                  {
                    int damageAmount = this.MakeDamage(living);
                    int criticalAmount = 0;
                    if (damageAmount != 0)
                    {
                      if (this.baseGame_0.RoomType == eRoomType.FightFootballTime && living is SimpleNpc)
                      {
                        damageAmount = this.GetFightFootballPoint((living as SimpleNpc).NpcInfo.ID);
                        if (this.living_0.Team == 1)
                          this.baseGame_0.blueScore += damageAmount;
                        else
                          this.baseGame_0.redScore += damageAmount;
                        this.living_0.ScoreArr.Add(damageAmount);
                      }
                      else
                        criticalAmount = this.MakeCriticalDamage(living, damageAmount);
                      this.living_0.OnTakedDamage(this.living_0, ref damageAmount, ref criticalAmount);
                      if (living.TakeDamage(this.living_0, ref damageAmount, ref criticalAmount, "Fire"))
                      {
                        int num7;
                        switch (living)
                        {
                          case SimpleBoss _:
                          case SimpleNpc _:
                            if (living.Config.KeepLife)
                            {
                              num7 = living.Blood != 1 ? 1 : 0;
                              break;
                            }
                            goto default;
                          default:
                            num7 = 1;
                            break;
                        }
                        if (num7 == 0)
                          this.m_actions.Add(new BombAction(this.float_7, ActionType.DO_ACTION, living.Id, 0, 0, 2));
                        else
                          this.m_actions.Add(new BombAction(this.float_7, ActionType.KILL_PLAYER, living.Id, damageAmount + criticalAmount, criticalAmount != 0 ? 2 : 1, living.Blood));
                      }
                      else
                        this.m_actions.Add(new BombAction(this.float_7, ActionType.UNFORZEN, living.Id, 0, 0, 0));
                      if (this.living_0 is Player && living is SimpleBoss)
                        this.living_0.TotalDameLiving += criticalAmount + damageAmount;
                      if (living is Player)
                      {
                        int dander = ((TurnedLiving) living).Dander;
                        if (this.living_0.FightBuffers.ConsortionReduceDander > 0)
                        {
                          dander -= dander * this.living_0.FightBuffers.ConsortionReduceDander / 100;
                          ((TurnedLiving) living).Dander = dander;
                        }
                        this.m_actions.Add(new BombAction(this.float_7, ActionType.DANDER, living.Id, dander, 0, 0));
                      }
                      if ((living is SimpleBoss || living is SimpleNpc) && this.baseGame_0.RoomType != eRoomType.FightFootballTime && living.DoAction > -1)
                        this.m_actions.Add(new BombAction(this.float_7, ActionType.DO_ACTION, living.Id, 0, 0, living.DoAction));
                    }
                    else if (living is SimpleBoss || living is SimpleNpc)
                      this.m_actions.Add(new BombAction(this.float_7, ActionType.DO_ACTION, living.Id, 0, 0, 0));
                    this.living_0.OnAfterKillingLiving(living, damageAmount, criticalAmount);
                    if (living.IsLiving)
                    {
                      living.StartFalling(true);
                      this.m_actions.Add(new BombAction(this.float_7, ActionType.START_MOVE, living.Id, living.X, living.Y, living.IsLiving ? 1 : 0));
                      if (this.living_0.BombFoul && living != this.living_0)
                        new ContinueReduceBlood(3, 5000, this.living_0).Start(living);
                      if (this.living_0.TiredShoot && living != this.living_0)
                        new ReduceStrengthEffect(3, 100).Start(living);
                      if (this.living_0.LockMove && living != this.living_0)
                        new LockDirectionEffect(2).Start(living);
                    }
                  }
                  else
                    this.m_actions.Add(new BombAction(this.float_7, ActionType.DO_ACTION, living.Id, 0, 0, 2));
                }
              }
            }
            List<Living> livingList = this.m_map.FindHitByHitPiont(collidePoint, this.m_petRadius);
            if (this.living_0.isPet && this.living_0.PetEffects.ActivePetHit && !this.baseGame_0.ArenaPK())
            {
              if (this.baseGame_0.RoomType == eRoomType.FightFootballTime)
                livingList = new List<Living>();
              foreach (Living target in livingList)
              {
                if (!target.Config.IsDown && !target.Config.IsGoal && !target.Config.IsShield && (!target.Config.KeepLife || target.Blood != 1))
                {
                  if (target != this.living_0)
                  {
                    int num8 = this.MakePetDamage(target, collidePoint);
                    if (num8 > 0)
                    {
                      int damageAmount = num8 * this.living_0.PetEffects.PetBaseAtt / 100;
                      int criticalAmount = this.MakeCriticalDamage(target, damageAmount);
                      if (target.PetTakeDamage(this.living_0, ref damageAmount, ref criticalAmount, "PetFire"))
                      {
                        if (target is Player)
                          this.m_petActions.Add(new BombAction(this.float_7, ActionType.PET, target.Id, damageAmount + criticalAmount, ((TurnedLiving) target).Dander, target.Blood));
                        else
                          this.m_petActions.Add(new BombAction(this.float_7, ActionType.PET, target.Id, damageAmount + criticalAmount, 0, target.Blood));
                      }
                    }
                  }
                }
                else
                  this.m_petActions.Add(new BombAction(0.0f, ActionType.NULLSHOOT, 0, 0, 0, 0));
              }
              if (livingList.Count == 0)
                this.m_petActions.Add(new BombAction(0.0f, ActionType.NULLSHOOT, 0, 0, 0, 0));
              this.living_0.PetEffects.ActivePetHit = false;
              break;
            }
            break;
        }
        this.Die();
      }
      finally
      {
        this.living_0.SyncAtTime = true;
        foreach (Living living in hitByHitPiont)
          living.SyncAtTime = true;
      }
    }

    protected int MakeDamage(Living target)
    {
      if (target.Config.IsChristmasBoss || this.baseGame_0.RoomType == eRoomType.FightFootballTime && target is Player)
        return 1;
      double baseDamage = this.living_0.BaseDamage;
      double num1 = target.BaseGuard;
      double num2 = target.Defence + target.MagicDefence;
      double num3 = this.living_0.Attack + target.MagicAttack;
      if (target.AddArmor && (target as Player).DeputyWeapon != null)
      {
        int hertAddition = (int) target.getHertAddition((target as Player).DeputyWeapon);
        num1 += (double) hertAddition;
        num2 += (double) hertAddition;
      }
      if (this.living_0.IgnoreArmor)
      {
        num1 = 0.0;
        num2 = 0.0;
      }
      if (this.living_0.IgnoreGuard > 0 && !this.living_0.IgnoreArmor)
      {
        num1 -= num1 / 100.0 * (double) this.living_0.IgnoreGuard;
        num2 -= num2 / 100.0 * (double) this.living_0.IgnoreGuard;
      }
      float currentDamagePlus = this.living_0.CurrentDamagePlus;
      float currentShootMinus = this.living_0.CurrentShootMinus;
      double num4 = 0.95 * (num1 - (double) (3 * this.living_0.Grade)) / (500.0 + num1 - (double) (3 * this.living_0.Grade));
      double num5 = num2 - this.living_0.Lucky >= 0.0 ? 0.95 * (num2 - this.living_0.Lucky) / (600.0 + num2 - this.living_0.Lucky) : 0.0;
      double num6 = ((double) this.living_0.FightBuffers.WorldBossAddDamage * (1.0 - (num1 / 200.0 + num2 * 0.003)) + baseDamage * (1.0 + num3 * 0.001) * (1.0 - (num4 + num5 - num4 * num5))) * (double) currentDamagePlus * (double) currentShootMinus;
      Point p = new Point(this.X, this.Y);
      double num7 = target.Distance(p);
      if (num7 >= (double) this.m_radius)
        return 0;
      if (this.living_0 is Player && target is Player && target != this.living_0)
        this.baseGame_0.AddAction((IAction) new FightAchievementAction(this.living_0, 3, this.living_0.Direction, 1200));
      double num8 = num6 * (1.0 - num7 / (double) this.m_radius / 4.0);
      return num8 < 0.0 ? 1 : (int) num8;
    }

    protected int MakePetDamage(Living target, Point p)
    {
      if (target.Config.IsWorldBoss || this.living_0.Game.RoomType == eRoomType.ActivityDungeon)
        return 0;
      if (target.Config.IsChristmasBoss)
        return 1;
      double baseDamage = this.living_0.BaseDamage;
      double num1 = target.BaseGuard;
      double num2 = target.Defence;
      double attack = this.living_0.Attack;
      if (target.AddArmor && (target as Player).DeputyWeapon != null)
      {
        int hertAddition = (int) target.getHertAddition((target as Player).DeputyWeapon);
        num1 += (double) hertAddition;
        num2 += (double) hertAddition;
      }
      if (this.living_0.IgnoreArmor)
      {
        num1 = 0.0;
        num2 = 0.0;
      }
      float currentDamagePlus = this.living_0.CurrentDamagePlus;
      double num3 = 0.95 * (num1 - (double) (3 * this.living_0.Grade)) / (500.0 + num1 - (double) (3 * this.living_0.Grade));
      double num4 = num2 - this.living_0.Lucky >= 0.0 ? 0.95 * (num2 - this.living_0.Lucky) / (600.0 + num2 - this.living_0.Lucky) : 0.0;
      double num5 = baseDamage * (1.0 + attack * 0.001) * (1.0 - (num3 + num4 - num3 * num4)) * (double) currentDamagePlus;
      return num5 < 0.0 ? 1 : (int) num5;
    }

    protected int MakeCriticalDamage(Living target, int baseDamage)
    {
      double lucky = this.living_0.Lucky;
      bool flag = lucky * 45.0 / (800.0 + lucky) + (double) this.living_0.PetEffects.CritRate > (double) this.baseGame_0.Random.Next(100);
      if (this.living_0.PetEffects.CritActive)
      {
        flag = true;
        this.living_0.PetEffects.CritActive = false;
      }
      if (!flag)
        return 0;
      int num1 = target.ReduceCritFisrtGem + target.ReduceCritSecondGem;
      int num2 = (int) ((0.5 + lucky * 0.00015) * (double) baseDamage) * (100 - num1) / 100;
      if (this.living_0.FightBuffers.ConsortionAddCritical > 0)
        num2 += this.living_0.FightBuffers.ConsortionAddCritical;
      return num2;
    }

    protected int GetFightFootballPoint(int livingID)
    {
      switch (livingID)
      {
        case 10005:
          return 1;
        case 10006:
          return 2;
        case 10007:
          return 3;
        case 10008:
          return 4;
        case 10009:
          return 5;
        default:
          return 1;
      }
    }

    protected override void FlyoutMap()
    {
      this.m_actions.Add(new BombAction(this.float_7, ActionType.FLY_OUT, 0, 0, 0, 0));
      base.FlyoutMap();
    }
  }
}
