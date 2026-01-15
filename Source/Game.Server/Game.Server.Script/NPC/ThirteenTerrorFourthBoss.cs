// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenTerrorFourthBoss
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
  public class ThirteenTerrorFourthBoss : ABrain
  {
    public int attackingTurn = 0;
    private Player target = (Player) null;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private static string[] AllAttackChat = new string[1]
    {
      "Bạn sẽ trả giá cho việc này ! "
    };
    private static string[] ShootChat = new string[3]
    {
      "Tôi không muốn chỉ là lãng phí khi bạn đánh bại!",
      "Oh, bạn chơi tốt đấy, <br/>ha ha ha ha!",
      "Xem tôi là danh dự của bạn!"
    };
    private static string[] CallChat = new string[1]
    {
      "Các, <br/>Boom con của ta !"
    };
    private static string[] AngryChat = new string[1]
    {
      "Sức mạnh cuối cùng !"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "I want kill you ?"
    };
    private static string[] SealChat = new string[1]
    {
      "Hãy đón nhận cái nón đến tột cùng !"
    };
    private static string[] KillPlayerChat = new string[2]
    {
      "Địa ngục là điểm đến duy nhất của ngươi !",
      "Quá dễ để ta tiêu diệt."
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X < 158)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 300);
      else if (this.attackingTurn == 0)
      {
        this.CallDeadZone();
        ++this.attackingTurn;
      }
      else if (this.attackingTurn == 1)
      {
        this.AttackInDeadZone();
        ++this.attackingTurn;
      }
      else if (this.attackingTurn == 2)
      {
        this.PersonalActack();
        ++this.attackingTurn;
      }
      else
      {
        this.AllAttack();
        this.attackingTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void CallDeadZone()
    {
      this.Body.PlayMovie("beatA", 2000, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateMovie), 4000);
    }

    public void CreateMovie()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(800, this.Body.Y, "moive", "asset.game.ten.tedabiaoji", "out", 1, 0);
    }

    public void CreateEffect()
    {
      if (this.target == null)
        return;
      this.m_front = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.target.X, this.target.Y, "effect", "asset.game.ten.qunbao", "out", 1, 0);
    }

    public void AllAttack()
    {
      this.Body.PlayMovie("beatA", 1000, 1000);
      this.Body.RangeAttacking(this.Body.X - 1500, this.Body.X + 1500, "cry", 4000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.MultiMovie), 4000);
      this.Body.CallFuction(new LivingCallBack(this.Out), 5000);
    }

    private void MultiMovie()
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allFightPlayer.X, allFightPlayer.Y, "boom", "asset.game.ten.qunbao", "out", 1, 0);
    }

    public void Out()
    {
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_front == null)
        return;
      this.Game.RemovePhysicalObj(this.m_front, true);
      this.m_front = (PhysicalObj) null;
    }

    public void AttackInDeadZone()
    {
      int index = this.Game.Random.Next(0, ThirteenTerrorFourthBoss.AngryChat.Length);
      this.Body.Say(ThirteenTerrorFourthBoss.AngryChat[index], 1, 0);
      this.Body.PlayMovie("beatD", 3000, 0);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.RangeAttacking(this.Body.X, 1400, "cry", 4000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Out), 5000);
    }

    public void PersonalActack()
    {
      this.Body.PlayMovie("beatA", 1000, 1000);
      this.target = this.Game.FindRandomPlayer();
      this.Body.CurrentDamagePlus = 2f;
      this.Body.RangeAttacking(this.target.X - 20, this.target.X + 20, "cry", 2000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.CreateEffect), 2000);
      this.Body.CallFuction(new LivingCallBack(this.Out), 3000);
    }

    public void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 100f;
      int index = this.Game.Random.Next(0, ThirteenTerrorFourthBoss.KillAttackChat.Length);
      this.Body.Say(ThirteenTerrorFourthBoss.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3300, (List<Player>) null);
    }
  }
}
