// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.SimpleNpc
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.AI;
using Game.Logic.AI.Npc;
using Game.Server.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class SimpleNpc : Living
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private NpcInfo npcInfo_0;
    private ABrain abrain_0;
    public int TotalCure;

    public NpcInfo NpcInfo => this.npcInfo_0;

    public SimpleNpc(int id, BaseGame game, NpcInfo npcInfo, int type, int direction)
      : base(id, game, npcInfo.Camp, npcInfo.Name, npcInfo.ModelID, npcInfo.Blood, npcInfo.Immunity, direction)
    {
      if (type == 0)
        this.Type = eLivingType.SimpleNpc;
      else
        this.Type = eLivingType.SimpleNpc1;
      this.npcInfo_0 = npcInfo;
      this.abrain_0 = ScriptMgr.CreateInstance(npcInfo.Script) as ABrain;
      if (this.abrain_0 == null)
      {
        SimpleNpc.ilog_0.ErrorFormat("Can't create abrain :{0}", (object) npcInfo.Script);
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
        SimpleNpc.ilog_0.ErrorFormat("SimpleNpc Created error:{1}", (object) ex);
      }
    }

    public override void Reset()
    {
      this.Agility = (double) this.npcInfo_0.Agility;
      this.Attack = (double) this.npcInfo_0.Attack;
      this.BaseDamage = (double) this.npcInfo_0.BaseDamage;
      this.BaseGuard = (double) this.npcInfo_0.BaseGuard;
      this.Lucky = (double) this.npcInfo_0.Lucky;
      this.Grade = this.npcInfo_0.Level;
      this.Experience = this.npcInfo_0.Experience;
      this.TotalCure = 0;
      this.SetRect(this.npcInfo_0.X, this.npcInfo_0.Y, this.npcInfo_0.Width, this.npcInfo_0.Height);
      this.SetRelateDemagemRect(this.npcInfo_0.X, this.npcInfo_0.Y, this.npcInfo_0.Width, this.npcInfo_0.Height);
      base.Reset();
    }

    public void GetDropItemInfo()
    {
      if (!(this.m_game.CurrentLiving is Player))
        return;
      Player currentLiving = this.m_game.CurrentLiving as Player;
      List<SqlDataProvider.Data.ItemInfo> info = (List<SqlDataProvider.Data.ItemInfo>) null;
      DropInventory.NPCDrop(this.npcInfo_0.DropId, ref info);
      if (info != null)
      {
        foreach (SqlDataProvider.Data.ItemInfo cloneItem in info)
        {
          if (cloneItem != null && cloneItem.Template.CategoryID != 10)
            currentLiving.PlayerDetail.AddTemplate(cloneItem, eBageType.TempBag, cloneItem.Count, eGameView.dungeonTypeGet);
        }
      }
    }

    public override void Die()
    {
      this.GetDropItemInfo();
      base.Die();
    }

    public override void Die(int delay)
    {
      this.GetDropItemInfo();
      base.Die(delay);
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
        SimpleNpc.ilog_0.ErrorFormat("SimpleNpc BeginNewTurn error:{1}", (object) ex);
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
        SimpleNpc.ilog_0.ErrorFormat("SimpleNpc StartAttacking error:{1}", (object) ex);
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
        SimpleNpc.ilog_0.ErrorFormat("SimpleNpc Dispose error:{1}", (object) ex);
      }
    }
  }
}
