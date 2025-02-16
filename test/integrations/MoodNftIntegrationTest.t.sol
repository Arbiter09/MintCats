// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft moodNft;
    string public constant HAPPY_MOOD_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
    string public constant HAPPY_MOOD_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ01qQXdJREl3TUNJZ2QybGtkR2c5SWpRd01DSWdJR2hsYVdkb2REMGlOREF3SWlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpUGdvZ0lEeGphWEpqYkdVZ1kzZzlJakV3TUNJZ1kzazlJakV3TUNJZ1ptbHNiRDBpZVdWc2JHOTNJaUJ5UFNJM09DSWdjM1J5YjJ0bFBTSmliR0ZqYXlJZ2MzUnliMnRsTFhkcFpIUm9QU0l6SWk4K0NpQWdQR2NnWTJ4aGMzTTlJbVY1WlhNaVBnb2dJQ0FnUEdOcGNtTnNaU0JqZUQwaU56QWlJR041UFNJNE1pSWdjajBpTVRJaUx6NEtJQ0FnSUR4amFYSmpiR1VnWTNnOUlqRXlOeUlnWTNrOUlqZ3lJaUJ5UFNJeE1pSXZQZ29nSUR3dlp6NEtJQ0E4Y0dGMGFDQmtQU0p0TVRNMkxqZ3hJREV4Tmk0MU0yTXVOamtnTWpZdU1UY3ROalF1TVRFZ05ESXRPREV1TlRJdExqY3pJaUJ6ZEhsc1pUMGlabWxzYkRwdWIyNWxPeUJ6ZEhKdmEyVTZJR0pzWVdOck95QnpkSEp2YTJVdGQybGtkR2c2SURNN0lpOCtDand2YzNablBnPT0ifQ==";
    string public constant SAD_MOOD_IMAGE_URI =
        "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKCXhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKCXhtbG5zOmNjPSJodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9ucyMiCgl4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiCgl4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgoJeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgoJeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiCglpZD0ic2hhcmluZ2FuIgoJd2lkdGg9IjMwMCIKCWhlaWdodD0iMzAwIj4KCTxkZWZzCgkJaWQ9ImRlZnMiPgoJCTxyYWRpYWxHcmFkaWVudAoJCQlpZD0iZ3IiPgoJCQk8c3RvcAoJCQkJb2Zmc2V0PSIwIgoJCQkJc3R5bGU9InN0b3AtY29sb3I6IzY2MDAwMDsgc3RvcC1vcGFjaXR5OiAxOyIKCQkJCWlkPSJzdDEiIC8+CgkJCTxzdG9wCgkJCQlzdHlsZT0ic3RvcC1jb2xvcjojYzMwMDAwOyBzdG9wLW9wYWNpdHk6IDE7IgoJCQkJb2Zmc2V0PSIwLjUiCgkJCQlpZD0ic3QyIi8+CgkJCTxzdG9wCgkJCQlzdHlsZT0ic3RvcC1jb2xvcjojYTAwMDAwOyBzdG9wLW9wYWNpdHk6IDE7IgoJCQkJb2Zmc2V0PSIxIgoJCQkJaWQ9InN0MyIvPgoJCTwvcmFkaWFsR3JhZGllbnQ+Cgk8L2RlZnM+Cgk8Y2lyY2xlCgkJc3R5bGU9ImZpbGw6IHVybCgjZ3IpOyBzdHJva2U6IzAwMDsgc3Ryb2tlLXdpZHRoOjEwOyIKCQljeD0iMTUwIgoJCWN5PSIxNTAiCgkJcj0iMTQ1IgoJCWlkPSJpcmlzIiAvPgoJPGcKCQlpZD0idG9tb2UgMSI+CgkJPHBhdGgKCQkJc3R5bGU9ImZpbGw6bm9uZTsgc3Ryb2tlOiMwMDA7IHN0cm9rZS13aWR0aDogNTsiCgkJCWQ9Ik0yMDAsMTUwIEMgMjAwLDIxNSAxNzAsMjc1IDE1MCwyOTUgQyAxMzAsMjc1IDEwMCwyMTUgMTAwLDE1MCBDIDEwMCw4NSAxMzAsMjUgMTUwLDUgQyAxNzAsMjUgMjAwLDg1IDIwMCwxNTAgeiIKCQkJaWQ9InRvbW9lIDFhIiAvPgoJCTxwYXRoCgkJCXN0eWxlPSJmaWxsOiMwMDA7IgoJCQlkPSJNIDI3NSw3Ny41IEMgMjYwLDQwIDIwMCwwIDE1MCw1IEMgMTcwLDMwIDE4My40LDU1LjEgMTkwLDgwIEMgMjE1LDc1IDI0NC4yLDcxLjcgMjc1LDc3LjUgeiIKCQkJaWQ9InRvbW9lIDFiIiAvPgoJCTx1c2UKCQkJeGxpbms6aHJlZj0iI3RvbW9lIDFiIgoJCQl0cmFuc2Zvcm09InJvdGF0ZSgxODAgMTUwIDE1MCkiCgkJCWlkPSJ0b21vZSAxYyIgLz4KCTwvZz4KCTx1c2UKCQl4bGluazpocmVmPSIjdG9tb2UgMSIKCQl0cmFuc2Zvcm09InJvdGF0ZSgxMjAgMTUwIDE1MCkiCgkJaWQ9InRvbW9lIDIiIC8+Cgk8dXNlCgkJeGxpbms6aHJlZj0iI3RvbW9lIDEiCgkJdHJhbnNmb3JtPSJyb3RhdGUoLTEyMCAxNTAgMTUwKSIKCQlpZD0idG9tb2UgMyIgLz4KCTxjaXJjbGUKCQlzdHlsZT0iZmlsbDojMDAwOyIKCQljeD0iMTUwIgoJCWN5PSIxNTAiCgkJcj0iMjAiCgkJaWQ9ImNlbnRlciIvPgo8L3N2Zz4=";

    string public constant SAD_MOOD_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBEOTRiV3dnZG1WeWMybHZiajBpTVM0d0lpQmxibU52WkdsdVp6MGlWVlJHTFRnaUlITjBZVzVrWVd4dmJtVTlJbTV2SWo4K0NqeHpkbWNLQ1hodGJHNXpPbVJqUFNKb2RIUndPaTh2Y0hWeWJDNXZjbWN2WkdNdlpXeGxiV1Z1ZEhNdk1TNHhMeUlLQ1hodGJHNXpPbU5qUFNKb2RIUndPaTh2WTNKbFlYUnBkbVZqYjIxdGIyNXpMbTl5Wnk5dWN5TWlDZ2w0Yld4dWN6cHlaR1k5SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpFNU9Ua3ZNREl2TWpJdGNtUm1MWE41Ym5SaGVDMXVjeU1pQ2dsNGJXeHVjenB6ZG1jOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklnb0plRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklnb0plRzFzYm5NNmVHeHBibXM5SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpFNU9Ua3ZlR3hwYm1zaUNnbHBaRDBpYzJoaGNtbHVaMkZ1SWdvSmQybGtkR2c5SWpNd01DSUtDV2hsYVdkb2REMGlNekF3SWo0S0NUeGtaV1p6Q2drSmFXUTlJbVJsWm5NaVBnb0pDVHh5WVdScFlXeEhjbUZrYVdWdWRBb0pDUWxwWkQwaVozSWlQZ29KQ1FrOGMzUnZjQW9KQ1FrSmIyWm1jMlYwUFNJd0lnb0pDUWtKYzNSNWJHVTlJbk4wYjNBdFkyOXNiM0k2SXpZMk1EQXdNRHNnYzNSdmNDMXZjR0ZqYVhSNU9pQXhPeUlLQ1FrSkNXbGtQU0p6ZERFaUlDOCtDZ2tKQ1R4emRHOXdDZ2tKQ1FsemRIbHNaVDBpYzNSdmNDMWpiMnh2Y2pvall6TXdNREF3T3lCemRHOXdMVzl3WVdOcGRIazZJREU3SWdvSkNRa0piMlptYzJWMFBTSXdMalVpQ2drSkNRbHBaRDBpYzNReUlpOCtDZ2tKQ1R4emRHOXdDZ2tKQ1FsemRIbHNaVDBpYzNSdmNDMWpiMnh2Y2pvallUQXdNREF3T3lCemRHOXdMVzl3WVdOcGRIazZJREU3SWdvSkNRa0piMlptYzJWMFBTSXhJZ29KQ1FrSmFXUTlJbk4wTXlJdlBnb0pDVHd2Y21Ga2FXRnNSM0poWkdsbGJuUStDZ2s4TDJSbFpuTStDZ2s4WTJseVkyeGxDZ2tKYzNSNWJHVTlJbVpwYkd3NklIVnliQ2dqWjNJcE95QnpkSEp2YTJVNkl6QXdNRHNnYzNSeWIydGxMWGRwWkhSb09qRXdPeUlLQ1FsamVEMGlNVFV3SWdvSkNXTjVQU0l4TlRBaUNna0pjajBpTVRRMUlnb0pDV2xrUFNKcGNtbHpJaUF2UGdvSlBHY0tDUWxwWkQwaWRHOXRiMlVnTVNJK0Nna0pQSEJoZEdnS0NRa0pjM1I1YkdVOUltWnBiR3c2Ym05dVpUc2djM1J5YjJ0bE9pTXdNREE3SUhOMGNtOXJaUzEzYVdSMGFEb2dOVHNpQ2drSkNXUTlJazB5TURBc01UVXdJRU1nTWpBd0xESXhOU0F4TnpBc01qYzFJREUxTUN3eU9UVWdReUF4TXpBc01qYzFJREV3TUN3eU1UVWdNVEF3TERFMU1DQkRJREV3TUN3NE5TQXhNekFzTWpVZ01UVXdMRFVnUXlBeE56QXNNalVnTWpBd0xEZzFJREl3TUN3eE5UQWdlaUlLQ1FrSmFXUTlJblJ2Ylc5bElERmhJaUF2UGdvSkNUeHdZWFJvQ2drSkNYTjBlV3hsUFNKbWFXeHNPaU13TURBN0lnb0pDUWxrUFNKTklESTNOU3czTnk0MUlFTWdNall3TERRd0lESXdNQ3d3SURFMU1DdzFJRU1nTVRjd0xETXdJREU0TXk0MExEVTFMakVnTVRrd0xEZ3dJRU1nTWpFMUxEYzFJREkwTkM0eUxEY3hMamNnTWpjMUxEYzNMalVnZWlJS0NRa0phV1E5SW5SdmJXOWxJREZpSWlBdlBnb0pDVHgxYzJVS0NRa0plR3hwYm1zNmFISmxaajBpSTNSdmJXOWxJREZpSWdvSkNRbDBjbUZ1YzJadmNtMDlJbkp2ZEdGMFpTZ3hPREFnTVRVd0lERTFNQ2tpQ2drSkNXbGtQU0owYjIxdlpTQXhZeUlnTHo0S0NUd3ZaejRLQ1R4MWMyVUtDUWw0YkdsdWF6cG9jbVZtUFNJamRHOXRiMlVnTVNJS0NRbDBjbUZ1YzJadmNtMDlJbkp2ZEdGMFpTZ3hNakFnTVRVd0lERTFNQ2tpQ2drSmFXUTlJblJ2Ylc5bElESWlJQzgrQ2drOGRYTmxDZ2tKZUd4cGJtczZhSEpsWmowaUkzUnZiVzlsSURFaUNna0pkSEpoYm5ObWIzSnRQU0p5YjNSaGRHVW9MVEV5TUNBeE5UQWdNVFV3S1NJS0NRbHBaRDBpZEc5dGIyVWdNeUlnTHo0S0NUeGphWEpqYkdVS0NRbHpkSGxzWlQwaVptbHNiRG9qTURBd095SUtDUWxqZUQwaU1UVXdJZ29KQ1dONVBTSXhOVEFpQ2drSmNqMGlNakFpQ2drSmFXUTlJbU5sYm5SbGNpSXZQZ284TDNOMlp6ND0ifQ==";

    DeployMoodNft deployer;

    address USER = makeAddr("user");
    address ATTACKER = makeAddr("attacker");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        console.log(moodNft.tokenURI(0));

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_MOOD_URI))
        );
    }

    function testNewlyMintedNftIsHappy() public {
        vm.prank(USER);
        moodNft.mintNft();

        console.log(moodNft.tokenURI(0));

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(HAPPY_MOOD_URI))
        );
    }

    function testFlipMoodBackToHappy() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        vm.prank(USER);
        moodNft.flipMood(0);

        assertEq(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))),
            keccak256(abi.encodePacked(HAPPY_MOOD_URI))
        );
    }

    function testOnlyOwnerCanFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(ATTACKER);
        vm.expectRevert(MoodNft.MoofNft__CantFlipMoodIfNotOwner.selector);
        moodNft.flipMood(0);
    }

    function testMintingMultipleNfts() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.mintNft();

        assertEq(moodNft.ownerOf(0), USER);
        assertEq(moodNft.ownerOf(1), USER);
    }
}
