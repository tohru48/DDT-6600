// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.GoblinFirst
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
  public class GoblinFirst : ABrain
  {
    private int m_attackTurn = 0;
    private int m_turn = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_wallLeft = (PhysicalObj) null;
    private PhysicalObj m_wallRight = (PhysicalObj) null;
    private int IsEixt = 0;
    private int npcID = 1310;
    private static string[] AllAttackChat = new string[3]
    {
      "要地震喽！！<br/>各位请扶好哦",
      "把你武器震下来！",
      "看你们能还经得起几下！！"
    };
    private static string[] ShootChat = new string[3]
    {
      "让你知道什么叫百发百中！",
      "送你一个球~你可要接好啦",
      "你们这群无知的低等庶民"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
      "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"
    };
    private static string[] KillPlayerChat = new string[3]
    {
      "马迪亚斯不要再控制我！",
      "这就是挑战我的下场！",
      "不！！这不是我的意愿… "
    };
    private static string[] AddBooldChat = new string[3]
    {
      "扭啊扭~<br/>扭啊扭~~",
      "哈利路亚~<br/>路亚路亚~~",
      "呀呀呀，<br/>好舒服啊！"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "君临天下！！"
    };
    private static string[] FrostChat = new string[3]
    {
      "来尝尝这个吧",
      "让你冷静一下",
      "你们激怒了我"
    };
    private static string[] WallChat = new string[2]
    {
      "神啊，赐予我力量吧！",
      "绝望吧，看我的水晶防护墙！"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
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
        this.NextAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
        ++this.m_attackTurn;
      else if (this.m_attackTurn == 2)
        ++this.m_attackTurn;
      else if (this.m_attackTurn == 3)
        ++this.m_attackTurn;
      else if (this.m_attackTurn == 4)
      {
        this.NextAttack();
        ++this.m_attackTurn;
      }
      else
        this.m_attackTurn = 0;
    }

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, GoblinFirst.KillAttackChat.Length);
      if (this.m_turn == 0)
      {
        this.Body.CurrentDamagePlus = 10f;
        this.Body.Say(GoblinFirst.KillAttackChat[index], 1, 13000);
        this.Body.PlayMovie("beat1", 15000, 0);
        this.Body.RangeAttacking(fx, tx, "cry", 17000, (List<Player>) null);
        ++this.m_turn;
      }
      else
      {
        this.Body.CurrentDamagePlus = 10f;
        this.Body.Say(GoblinFirst.KillAttackChat[index], 1, 0);
        this.Body.PlayMovie("beat1", 2000, 0);
        this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
      }
    }

    private void ProtectingWall()
    {
      this.m_wallRight = ((PVEGame) this.Game).CreatePhysicalObj(1460, 580, "wallLeft", "", "1", 1, 0);
      this.m_wallRight.SetRect(-75, -159, 53, 130);
      int index = this.Game.Random.Next(0, GoblinFirst.WallChat.Length);
      this.Body.Say(GoblinFirst.WallChat[index], 1, 0);
    }

    private void NextAttack()
    {
      this.Body.PlayMovie("beatA", 1000, 4000);
      this.Body.CallFuction(new LivingCallBack(this.GoAttack), 3000);
    }

    private void GoAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer.X, randomPlayer.Y, "wallLeft", "asset.game.4.xiaopao", "1", 1, 0);
      this.Body.Shoot(174, randomPlayer.X, randomPlayer.Y, 1, 1, 1, 0);
      this.Body.RangeAttacking(randomPlayer.X + 20, randomPlayer.X - 20, "cry", 500, (List<Player>) null);
    }

    public override void OnStopAttacking()
    {
      base.OnStopAttacking();
      if (this.m_moive == null)
        return;
      this.Game.RemovePhysicalObj(this.m_moive, true);
      this.m_moive = (PhysicalObj) null;
    }
  }
}
