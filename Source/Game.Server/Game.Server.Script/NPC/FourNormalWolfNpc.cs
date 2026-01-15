// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourNormalWolfNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourNormalWolfNpc : ABrain
  {
    private int m_attackTurn = 0;
    private int m_run = 0;
    protected Player m_targer;
    private int Dander = 0;
    private List<SimpleNpc> Children = new List<SimpleNpc>();
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
        this.Jump();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.WalkB();
        ++this.m_attackTurn;
      }
      else
      {
        this.WalkB();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void Jump()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.JumpToSpeed(randomPlayer.X, randomPlayer.Y, "jump", 1000, 1, 1000, new LivingCallBack(this.Fall));
      this.Body.SetRelateDemagemRect(-41, -100, 83, 70);
    }

    public void Fall()
    {
      this.Body.PlayMovie("fall", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 100, this.Body.X + 100, "cry", 1000, (List<Player>) null);
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.SetRelateDemagemRect(-41, -100, 83, 70);
    }

    private void WalkA()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      int num = this.Game.Random.Next(100, 170);
      foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
        this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      if (this.Body.X < 400)
        this.Body.MoveTo(this.Body.X + num, this.Body.Y, "walkA", 1000, "", 4);
      else
        this.Body.MoveTo(this.Body.X - num, this.Body.Y, "walkA", 1000, "", 4);
      this.Body.CallFuction(new LivingCallBack(this.AllAttack), 2600);
    }

    private void AllAttack()
    {
      this.ChangeDirection(1);
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatA", 0, 0);
      this.ChangeDirection(3);
    }

    private void AllAttack2()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatB", 0, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 1000, (List<Player>) null);
      this.Body.SetRelateDemagemRect(-41, -100, 83, 70);
    }

    private void WalkB()
    {
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      if (this.m_run == 0)
      {
        this.Beat(this.m_targer);
        this.m_run = 1;
      }
      else
      {
        this.Beat2(this.m_targer);
        this.m_run = 0;
      }
    }

    private void Beat(Player player)
    {
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      int num = (int) player.Distance(this.Body.X, this.Body.Y);
      if (num > 200)
      {
        if (player.X > this.Body.X)
          this.Body.MoveTo(this.Body.X + num - 150, this.Body.Y, "walkB", 0, "", 12);
        else
          this.Body.MoveTo(this.Body.X - num + 150, this.Body.Y, "walkB", 0, "", 12);
      }
      if (num < 200)
      {
        this.Body.PlayMovie("beatB", 2000, 0);
        this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
        this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 2100);
      }
      else
      {
        this.Body.PlayMovie("beatB", num * 3 + 200, 0);
        this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
        this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), num * 4);
      }
    }

    private void Beat2(Player player)
    {
      int num = (int) player.Distance(this.Body.X, this.Body.Y);
      this.m_targer = this.Game.FindNearestPlayer(this.Body.X, this.Body.Y);
      if (num > 200)
      {
        if (player.X > this.Body.X)
          this.Body.MoveTo(this.Body.X + num - 150, this.Body.Y, "walkB", 0, "", 12);
        else
          this.Body.MoveTo(this.Body.X - num + 150, this.Body.Y, "walkB", 0, "", 12);
      }
      if (num < 200)
      {
        this.Body.PlayMovie("beatB", 2000, 0);
        this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
        this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), 2100);
      }
      else
      {
        this.Body.PlayMovie("beatB", num * 3 + 200, 0);
        this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
        this.Body.CallFuction(new LivingCallBack(this.RangeAttacking), num * 4);
      }
    }

    private void RangeAttacking()
    {
      this.Body.RangeAttacking(this.Body.X - 200, this.Body.X + 200, "", 0, (List<Player>) null);
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

    private void ChangeDirection(int count)
    {
      int direction = this.Body.Direction;
      for (int index = 0; index < count; ++index)
      {
        this.Body.ChangeDirection(-direction, index * 200 + 100);
        this.Body.ChangeDirection(direction, (index + 1) * 100 + index * 200);
      }
    }
  }
}
