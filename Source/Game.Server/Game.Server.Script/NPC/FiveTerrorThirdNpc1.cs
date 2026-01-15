// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FiveTerrorThirdNpc1
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FiveTerrorThirdNpc1 : ABrain
  {
    private int m_attackTurn = 0;
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
        this.KillAttack(0, 0);
      else if (this.m_attackTurn == 0)
      {
        this.In();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        ++this.m_attackTurn;
      }
      else
      {
        this.Beat();
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, FiveTerrorThirdNpc1.KillAttackChat.Length);
      this.Body.Say(FiveTerrorThirdNpc1.KillAttackChat[index], 1, 1000);
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void In()
    {
      this.Body.PlayMovie("AtoB", 3000, 0);
      Player randomPlayer = this.Game.FindRandomPlayer();
      randomPlayer.MoveTo(this.Body.X, this.Body.Y, "", 0, "", 3);
      randomPlayer.IsNoHole = true;
    }

    private void Beat()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatA", 1000, 4500);
      this.Body.RangeAttacking(this.Body.X - 10, this.Body.X + 10, "cry", 3000, (List<Player>) null);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
