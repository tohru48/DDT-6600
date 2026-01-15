// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenHardDevilBoss
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
  public class ThirteenHardDevilBoss : ABrain
  {
    private int m_attackTurn = 0;
    private int npcID = 5322;
    private int npcID2 = 5323;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private PhysicalObj moive;
    private PhysicalObj front;
    private PhysicalObj wallLeft = (PhysicalObj) null;
    private static string[] AllAttackChat = new string[3]
    {
      "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",
      "Hạ vũ khí xuống!",
      "Xem nếu bạn có thể đủ khả năng, một số ít!！"
    };
    private static string[] ShootChat = new string[3]
    {
      "Cho bạn biết những gì một cú sút vết nứt!",
      "Gửi cho bạn một quả bóng - bạn phải chọn Vâng",
      "Nhóm của bạn của những người dân thường ngu dốt và thấp"
    };
    private static string[] ShootedChat = new string[2]
    {
      "Ah ~ ~ Tại sao bạn tấn công? <br/> tôi đang làm gì?",
      "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu? <br/> tôi phải chiến đấu ..."
    };
    private static string[] AddBooldChat = new string[3]
    {
      "Xoắn ah xoay ~ <br/>xoắn ah xoay ~ ~ ~",
      "~ Hallelujah <br/>Luyaluya ~ ~ ~",
      "Yeah Yeah Yeah, <br/> để thoải mái!"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "Con rồng trong thế giới! !"
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
      {
        this.KillAttack(0, 0);
      }
      else
      {
        if (this.Body.State == 1)
          return;
        if (this.m_attackTurn == 0)
        {
          this.CallBell();
          ++this.m_attackTurn;
        }
        else if (this.m_attackTurn == 1)
        {
          this.BeatE();
          ++this.m_attackTurn;
        }
        else
        {
          this.BlackAttack();
          this.m_attackTurn = 0;
        }
      }
    }

    private void CallBell() => this.Body.PlayMovie("beatB", 3300, 0);

    private void BlackAttack()
    {
      this.Body.PlayMovie("beatA", 0, 3000);
      this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.Body.X, this.Body.Y, "top", "asset.game.4.heip", "out", 2, 1);
      this.Body.CallFuction(new LivingCallBack(this.AllAttack), 2500);
    }

    private void AllAttack()
    {
      this.Body.CurrentDamagePlus = 2.5f;
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 500, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.RemoveMove), 0);
    }

    private void RemoveMove()
    {
      if (this.moive != null)
      {
        this.Game.RemovePhysicalObj(this.moive, true);
        this.moive = (PhysicalObj) null;
      }
      if (this.front == null)
        return;
      this.Game.RemovePhysicalObj(this.front, true);
      this.front = (PhysicalObj) null;
    }

    private void BeatE()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.MoveTo(randomPlayer.X, randomPlayer.Y - 95, "fly", 1000, "", 16, new LivingCallBack(this.PersonalAttack));
    }

    private void PersonalAttack()
    {
      this.Body.CurrentDamagePlus = 5.5f;
      this.Body.PlayMovie("beatE", 3500, 0);
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.RangeAttacking(randomPlayer.X - 50, randomPlayer.X + 50, "cry", 5000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Run), 5000);
    }

    private void Run()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.MoveTo(850, 770, "fly", 1000, "", 16, new LivingCallBack(this.ChangeDirection));
    }

    private void ChangeDirection() => this.Body.Direction = this.Game.FindlivingbyDir(this.Body);

    private void CallHopquaidi()
    {
      this.Body.CurrentDamagePlus = 0.8f;
      int index = this.Game.Random.Next(0, ThirteenHardDevilBoss.ShootChat.Length);
      this.Body.Say(ThirteenHardDevilBoss.ShootChat[index], 1, 0);
      this.Game.Random.Next(400, 1300);
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.MoveTo(randomPlayer.X, randomPlayer.Y - 150, "fly", 3500, "", 16, new LivingCallBack(this.CallHopquaidi2));
      this.Body.PlayMovie("beatD", 3300, 2000);
    }

    private void BeatDame()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.MoveTo(randomPlayer.X, randomPlayer.Y - 150, "fly", 3500, "", 16, new LivingCallBack(this.GoBeatDame));
    }

    private void GoBeatDame()
    {
      int index = this.Game.Random.Next(0, ThirteenHardDevilBoss.AddBooldChat.Length);
      this.Body.Say(ThirteenHardDevilBoss.AddBooldChat[index], 1, 0);
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.SyncAtTime = true;
      this.Body.PlayMovie("beatE", 3300, 5000);
      this.Body.RangeAttacking(this.Body.X - 100, this.Body.X + 100, "cry", 5000, (List<Player>) null);
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirteenHardDevilBoss.KillAttackChat.Length);
      this.Body.Say(ThirteenHardDevilBoss.KillAttackChat[index], 1, 1000);
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void CallHopquaidi2()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      int x = this.Game.Random.Next(700, 1300);
      this.Body.SetXY(this.Body.X, 600);
      ((SimpleBoss) this.Body).CreateChild(this.npcID2, x, 900, 1000, 1, -1);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
