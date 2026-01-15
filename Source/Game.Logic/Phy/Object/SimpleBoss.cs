// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.SimpleBoss
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.AI.Npc;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Reflection;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class SimpleBoss : TurnedLiving
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private NpcInfo npcInfo_0;
    private ABrain abrain_0;
    private List<SimpleNpc> list_0;
    private List<SimpleBoss> list_1;
    private Dictionary<Player, int> dictionary_0;
    public int TotalCure;

    public NpcInfo NpcInfo => this.npcInfo_0;

    public List<SimpleNpc> Child => this.list_0;

    public int CurrentLivingNpcNum
    {
      get
      {
        int num = 0;
        foreach (Physics physics in this.Child)
        {
          if (!physics.IsLiving)
            ++num;
        }
        return this.Child.Count - num;
      }
    }

    public List<SimpleBoss> Boss => this.list_1;

    public int CurrentLivingBossNum
    {
      get
      {
        int num = 0;
        foreach (Physics physics in this.Boss)
        {
          if (!physics.IsLiving)
            ++num;
        }
        return this.Boss.Count - num;
      }
    }

    public SimpleBoss(
      int id,
      BaseGame game,
      NpcInfo npcInfo,
      int direction,
      int type,
      string actions)
      : base(id, game, npcInfo.Camp, npcInfo.Name, npcInfo.ModelID, npcInfo.Blood, npcInfo.Immunity, direction)
    {
      this.list_0 = new List<SimpleNpc>();
      this.list_1 = new List<SimpleBoss>();
      switch (type)
      {
        case 0:
          this.Type = eLivingType.SimpleBoss;
          break;
        case 1:
          this.Type = eLivingType.ClearEnemy;
          break;
        default:
          this.Type = (eLivingType) type;
          break;
      }
      this.ActionStr = actions;
      this.dictionary_0 = new Dictionary<Player, int>();
      this.npcInfo_0 = npcInfo;
      this.abrain_0 = ScriptMgr.CreateInstance(npcInfo.Script) as ABrain;
      if (this.abrain_0 == null)
      {
        SimpleBoss.ilog_0.ErrorFormat("Can't create abrain :{0}", (object) npcInfo.Script);
        this.abrain_0 = (ABrain) SimpleBrain.Simple;
      }
      this.abrain_0.Game = this.m_game;
      this.abrain_0.Body = (Living) this;
      try
      {
        this.abrain_0.OnCreated();
      }
      catch (Exception ex)
      {
        SimpleBoss.ilog_0.ErrorFormat("SimpleBoss Created error:{1}", (object) ex);
      }
    }

    public override void Reset()
    {
      if (this.Config.IsWorldBoss)
        this.m_maxBlood = int.MaxValue;
      else
        this.m_maxBlood = this.npcInfo_0.Blood;
      this.BaseDamage = (double) this.npcInfo_0.BaseDamage;
      this.BaseGuard = (double) this.npcInfo_0.BaseGuard;
      this.Attack = (double) this.npcInfo_0.Attack;
      this.Defence = (double) this.npcInfo_0.Defence;
      this.Agility = (double) this.npcInfo_0.Agility;
      this.Lucky = (double) this.npcInfo_0.Lucky;
      this.Grade = this.npcInfo_0.Level;
      this.Experience = this.npcInfo_0.Experience;
      this.m_delay = this.npcInfo_0.Agility;
      this.SetRect(this.npcInfo_0.X, this.npcInfo_0.Y, this.npcInfo_0.Width, this.npcInfo_0.Height);
      this.SetRelateDemagemRect(this.npcInfo_0.X, this.npcInfo_0.Y, this.npcInfo_0.Width, this.npcInfo_0.Height);
      base.Reset();
    }

    public override void Die() => base.Die();

    public override void Die(int delay) => base.Die(delay);

    public SimpleNpc FindFrostChild()
    {
      SimpleNpc frostChild = (SimpleNpc) null;
      foreach (SimpleNpc simpleNpc in this.Child)
      {
        if (simpleNpc.IsLiving && simpleNpc.IsFrost)
        {
          frostChild = simpleNpc;
          break;
        }
      }
      return frostChild;
    }

    public override bool TakeDamage(
      Living source,
      ref int damageAmount,
      ref int criticalAmount,
      string msg)
    {
      bool damage = base.TakeDamage(source, ref damageAmount, ref criticalAmount, msg);
      if (source is Player)
      {
        Player key = source as Player;
        int num = damageAmount + criticalAmount;
        if (this.dictionary_0.ContainsKey(key))
          this.dictionary_0[key] += num;
        else
          this.dictionary_0.Add(key, num);
      }
      return damage;
    }

    public Player FindMostHatefulPlayer()
    {
      if (this.dictionary_0.Count <= 0)
        return (Player) null;
      KeyValuePair<Player, int> keyValuePair1 = this.dictionary_0.ElementAt<KeyValuePair<Player, int>>(0);
      foreach (KeyValuePair<Player, int> keyValuePair2 in this.dictionary_0)
      {
        if (keyValuePair1.Value < keyValuePair2.Value)
          keyValuePair1 = keyValuePair2;
      }
      return keyValuePair1.Key;
    }

    public void CreateChild(int id, int x, int y, int disToSecond, int maxCount, int direction)
    {
      if (this.CurrentLivingNpcNum >= maxCount)
        return;
      if (maxCount - this.CurrentLivingNpcNum >= 2)
      {
        this.Child.Add(((PVEGame) this.Game).CreateNpc(id, x + disToSecond, y, 1, direction));
        this.Child.Add(((PVEGame) this.Game).CreateNpc(id, x, y, 1, direction));
      }
      else if (maxCount - this.CurrentLivingNpcNum == 1)
        this.Child.Add(((PVEGame) this.Game).CreateNpc(id, x, y, 1, direction));
    }

    public void CreateChild(
      int id,
      Point[] brithPoint,
      int maxCount,
      int maxCountForOnce,
      int type,
      int direction)
    {
      int num = this.Game.Random.Next(0, maxCountForOnce);
      for (int index1 = 0; index1 < num; ++index1)
      {
        int index2 = this.Game.Random.Next(0, brithPoint.Length);
        this.CreateChild(id, brithPoint[index2].X, brithPoint[index2].Y, 4, maxCount, direction);
      }
    }

    public void CreateBoss(
      int id,
      int x,
      int y,
      int direction,
      int disToSecond,
      int maxCount,
      string action)
    {
      this.CreateBoss(id, x, y, direction, 1, disToSecond, maxCount, action);
    }

    public void CreateBoss(
      int id,
      int x,
      int y,
      int direction,
      int type,
      int disToSecond,
      int maxCount,
      string action)
    {
      if (this.CurrentLivingBossNum >= maxCount)
        return;
      if (maxCount - this.CurrentLivingNpcNum >= 2)
      {
        this.Boss.Add(((PVEGame) this.Game).CreateBoss(id, x + disToSecond, y, direction, type, action));
        this.Boss.Add(((PVEGame) this.Game).CreateBoss(id, x, y, direction, type, action));
      }
      else if (maxCount - this.CurrentLivingBossNum == 1)
        this.Boss.Add(((PVEGame) this.Game).CreateBoss(id, x, y, direction, type, action));
    }

    public void RandomSay(string[] msg, int type, int delay, int finishTime)
    {
      if (this.Game.Random.Next(0, 2) != 1)
        return;
      int index = this.Game.Random.Next(0, ((IEnumerable<string>) msg).Count<string>());
      this.m_game.AddAction((IAction) new LivingSayAction((Living) this, msg[index], type, delay, finishTime));
    }

    public override void PrepareNewTurn()
    {
      base.PrepareNewTurn();
      try
      {
        this.abrain_0.OnBeginNewTurn();
      }
      catch (Exception ex)
      {
        SimpleBoss.ilog_0.ErrorFormat("SimpleBoss BeginNewTurn error:{1}", (object) ex);
      }
    }

    public override void PrepareSelfTurn()
    {
      base.PrepareSelfTurn();
      this.DefaultDelay = this.m_delay;
      this.AddDelay(this.npcInfo_0.Delay);
      try
      {
        this.abrain_0.OnBeginSelfTurn();
      }
      catch (Exception ex)
      {
        SimpleBoss.ilog_0.ErrorFormat("SimpleBoss BeginSelfTurn error:{1}", (object) ex);
      }
    }

    public override void StartAttacking()
    {
      base.StartAttacking();
      try
      {
        this.abrain_0.OnStartAttacking();
      }
      catch (Exception ex)
      {
        SimpleBoss.ilog_0.ErrorFormat("SimpleBoss StartAttacking error:{1}", (object) ex);
      }
      if (!this.IsAttacking)
        return;
      this.StopAttacking();
    }

    public override void StopAttacking()
    {
      base.StopAttacking();
      try
      {
        this.abrain_0.OnStopAttacking();
      }
      catch (Exception ex)
      {
        SimpleBoss.ilog_0.ErrorFormat("SimpleBoss StopAttacking error:{1}", (object) ex);
      }
    }

    public override void Dispose()
    {
      base.Dispose();
      try
      {
        this.abrain_0.Dispose();
      }
      catch (Exception ex)
      {
        SimpleBoss.ilog_0.ErrorFormat("SimpleBoss Dispose error:{1}", (object) ex);
      }
    }
  }
}
