// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourTerrorHawkNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourTerrorHawkNpc : ABrain
  {
    private int m_attackTurn = 0;
    private int Dander = 0;
    private List<SimpleNpc> Children = new List<SimpleNpc>();
    private PhysicalObj m_moive;
    private static string[] AllAttackChat = new string[3]
    {
      "你们这是自寻死路！",
      "你惹毛我了!",
      "超级无敌大地震……<br/>震……震…… "
    };
    private static string[] ShootChat = new string[2]
    {
      "砸你家玻璃。",
      "看哥打的可比你们准多了"
    };
    private static string[] KillPlayerChat = new string[2]
    {
      "送你回老家！",
      "就凭你还妄想能够打败我？"
    };
    private static string[] CallChat = new string[2]
    {
      "卫兵！ <br/>卫兵！！ ",
      "啵咕们！！<br/>给我些帮助！"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呦！很痛…",
      "我还顶的住…"
    };
    private static string[] JumpChat = new string[3]
    {
      "为了你们的胜利，<br/>向我开炮！",
      "你再往前半步我就把你给杀了！",
      "高！<br/>实在是高！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "超级肉弹！！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.Body.SetRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
      if (this.Body.Direction == -1)
        this.Body.SetRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
      else
        this.Body.SetRect(-((SimpleBoss) this.Body).NpcInfo.X - ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      if (this.m_attackTurn == 0)
      {
        this.WalkA();
        this.Angger();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.WalkA();
        this.Angger();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.CallBoss();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.CallBoss();
        ++this.m_attackTurn;
      }
      else
      {
        this.WalkA();
        this.Angger();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void WalkA()
    {
      this.Body.MoveTo(this.Game.Random.Next(200, 1389), this.Body.Y, "fly", 1200, "", 12, new LivingCallBack(this.AllAttack));
    }

    private void AllAttack()
    {
      this.Body.PlayMovie("beatA", 2000, 2000);
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.CallFuction(new LivingCallBack(this.CreateFeather), 3300);
    }

    private void AllAttack2()
    {
      this.Body.PlayMovie("beatA", 2000, 2000);
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.CallFuction(new LivingCallBack(this.CreateFeather), 3300);
    }

    private void CallBoss()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      int index = this.Game.Random.Next(0, FourTerrorHawkNpc.AllAttackChat.Length);
      this.Body.Say(FourTerrorHawkNpc.AllAttackChat[index], 1, 1000);
      this.Body.PlayMovie("cry", 2000, 0);
    }

    public void CreateFeather()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 1000, (List<Player>) null);
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer.X, randomPlayer.Y, "moive", "asset.game.4.feather", "out", 1, 0);
      this.Body.SetRelateDemagemRect(-41, -100, 50, 70);
    }

    public void Angger()
    {
      this.Body.State = 1;
      this.Dander += 100;
      ((TurnedLiving) this.Body).SetDander(this.Dander);
      if (this.Body.Direction == -1)
        this.Body.SetRelateDemagemRect(8, -252, 74, 50);
      else
        this.Body.SetRelateDemagemRect(-8, -252, 74, 50);
    }
  }
}
