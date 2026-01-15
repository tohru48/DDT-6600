// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourTerrorCattleBoss
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
  public class FourTerrorCattleBoss : ABrain
  {
    private int m_attackTurn = 0;
    private int currentCount = 0;
    private int Dander = 0;
    protected Player m_targer;
    private PhysicalObj m_moive;
    private List<SimpleNpc> m_child = new List<SimpleNpc>();
    private int npcID = 4307;
    private static string[] AllAttackChat = new string[3]
    {
      "Lần này thế nào hả ?",
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
    private static string[] CallChat = new string[1]
    {
      "Ngọn lửa câm giận<br/>hãy bừng cháy ...！ "
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

    public List<SimpleNpc> Child => this.m_child;

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
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 0);
      else if (this.m_attackTurn == 0)
      {
        if (this.CurrentLivingNpcNum > 1)
          this.Body.AddBlood(15000);
        this.AllAttack2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.PersonalAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Jump();
        ++this.m_attackTurn;
      }
      else
      {
        this.Physicallyinjured();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void Star()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.Body.X, this.Body.Y - 150, "moive", "game.crazytank.assetmap.Buff_powup", "", 1, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 2000);
    }

    private void Physicallboss()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.Body.X, this.Body.Y - 150, "moive", "game.crazytank.assetmap.Buff_powup", "", 1, 0);
    }

    public void CreateChild()
    {
    }

    private void Physicallyinjured()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("AtoB", 1000, 0);
    }

    private void AllAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatA", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
    }

    private void AllAttack2()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatB", 2000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
    }

    private void Healing()
    {
      this.Body.PlayMovie("beatC", 500, 0);
      this.Body.AddBlood(5000);
    }

    public void Jump()
    {
      this.Body.PlayMovie("jump", 1000, 6000);
      this.Body.JumpToSpeed(this.Game.FindRandomPlayer().X, this.Body.Y - 1000, "", 2500, 1, 10, new LivingCallBack(this.Jump2));
    }

    public void Jump2()
    {
      this.Body.PlayMovie("fall", 0, 0);
      this.Body.RangeAttacking(this.Body.X - 2000, this.Body.X + 2000, "cry", 0, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      this.Body.MoveTo(this.Body.X - 100, this.Body.Y, "walk", 1000, "", 6, new LivingCallBack(this.AllAttack));
    }

    public void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, FourTerrorCattleBoss.KillAttackChat.Length);
      this.Body.Say(FourTerrorCattleBoss.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3300, (List<Player>) null);
    }
  }
}
