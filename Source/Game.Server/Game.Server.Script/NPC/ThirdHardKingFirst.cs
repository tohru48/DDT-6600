// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdHardKingFirst
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
  public class ThirdHardKingFirst : ABrain
  {
    private int m_attackTurn = 0;
    private SimpleBoss m_boss = (SimpleBoss) null;
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingMoive2;
    private PhysicalObj m_kingMoive3;
    private PhysicalObj m_kingMoive4;
    private PhysicalObj m_wallLeft = (PhysicalObj) null;
    private int npcID = 3206;
    private int npcID2 = 3212;
    private static string[] AllAttackChat = new string[3]
    {
      "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",
      "Hạ vũ khí xuống!",
      "Xem nếu bạn có thể đủ khả năng, một số ít!！"
    };
    private static string[] CallChat = new string[2]
    {
      "Vệ binh! <br/> bảo vệ! ! ",
      "Boo đệm! ! <br/> cung cấp cho tôi một số trợ giúp!"
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 300)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 300);
      else if (this.m_attackTurn == 0)
      {
        this.In();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Summon2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Jump();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Jump2();
        ++this.m_attackTurn;
      }
      else
      {
        this.Healing();
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirdHardKingFirst.KillAttackChat.Length);
      this.Body.Say(ThirdHardKingFirst.KillAttackChat[index], 0, 1000);
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void In()
    {
      this.Body.PlayMovie("castA", 3000, 0);
      this.Body.Say("Kiên cố!", 0, 0);
      this.Body.CallFuction(new LivingCallBack(this.Star), 4000);
    }

    private void Star()
    {
      this.Body.CurrentDamagePlus = 1f;
      Player randomPlayer1 = this.Game.FindRandomPlayer();
      this.m_kingMoive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer1.X, randomPlayer1.Y, "1", "asset.game.4.dici", "out", 1, 0);
      Player randomPlayer2 = this.Game.FindRandomPlayer();
      this.m_kingMoive2 = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer2.X, randomPlayer2.Y, "2", "asset.game.4.dici", "out", 1, 0);
      Player randomPlayer3 = this.Game.FindRandomPlayer();
      this.m_kingMoive3 = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer3.X, randomPlayer3.Y, "3", "asset.game.4.dici", "out", 1, 0);
      Player randomPlayer4 = this.Game.FindRandomPlayer();
      this.m_kingMoive4 = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer4.X, randomPlayer4.Y, "4", "asset.game.4.dici", "out", 1, 0);
      this.Body.RangeAttacking(randomPlayer1.X + 10, randomPlayer1.X - 10, "cry", 3000, (List<Player>) null);
      this.Body.RangeAttacking(randomPlayer2.X + 10, randomPlayer2.X - 10, "cry", 3000, (List<Player>) null);
      this.Body.RangeAttacking(randomPlayer3.X + 10, randomPlayer3.X - 10, "cry", 3000, (List<Player>) null);
      this.Body.RangeAttacking(randomPlayer4.X + 10, randomPlayer4.X - 10, "cry", 3000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Remove), 800);
    }

    public void Remove()
    {
      if (this.m_kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive, true);
        this.m_kingMoive = (PhysicalObj) null;
      }
      if (this.m_kingMoive2 != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive2, true);
        this.m_kingMoive2 = (PhysicalObj) null;
      }
      if (this.m_kingMoive3 != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive3, true);
        this.m_kingMoive3 = (PhysicalObj) null;
      }
      if (this.m_kingMoive4 == null)
        return;
      this.Game.RemovePhysicalObj(this.m_kingMoive4, true);
      this.m_kingMoive4 = (PhysicalObj) null;
    }

    private void Jump()
    {
      this.Body.JumpTo(this.Body.X, this.Body.Y - 130, "", 1000, 1, 12, new LivingCallBack(this.NextAttack));
    }

    private void Jump2()
    {
      this.Body.PlayMovie("walk", 100, 1000);
      this.Body.FallFromTo(this.Body.X, this.Body.Y + 260, "", 1000, 0, 25, new LivingCallBack(this.NextAttack));
    }

    public void Healing()
    {
      this.Body.SyncAtTime = true;
      this.Body.AddBlood(5000);
      this.Body.PlayMovie("castA", 100, 400);
      this.Body.Say("Hồi phục sức mạnh", 0, 0);
    }

    private void Summon2()
    {
      int index = this.Game.Random.Next(0, ThirdHardKingFirst.CallChat.Length);
      this.Body.Say(ThirdHardKingFirst.CallChat[index], 0, 3300);
      this.Body.PlayMovie("call", 3500, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild2), 4000);
    }

    public void CreateChild2()
    {
      ((SimpleBoss) this.Body).CreateBoss(this.npcID, 1352, 227, -1, 430, 1, "");
    }

    private void NextAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.CurrentDamagePlus = 0.8f;
      int index = this.Game.Random.Next(0, ThirdHardKingFirst.ShootChat.Length);
      this.Body.Say(ThirdHardKingFirst.ShootChat[index], 0, 0);
      if (randomPlayer == null || !this.Body.ShootPoint(this.Game.Random.Next(randomPlayer.X - 20, randomPlayer.X + 20), randomPlayer.Y, 54, 1000, 10000, 1, 1f, 2300))
        return;
      this.Body.PlayMovie("beatA", 1500, 0);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
