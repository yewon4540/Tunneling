# .env 파일 경로
$envFilePath = ".\.env"

# .env 파일 확인
if (-Not (Test-Path $envFilePath)) {
    Write-Host ".env 파일이 존재하지 않습니다." -ForegroundColor Red
    exit 1
}

# .env 파일 로드
Get-Content $envFilePath | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        $name = $matches[1]
        $value = $matches[2]
        Set-Variable -Name $name -Value $value
    }
}

# 디버깅: 변수 확인
Write-Host "IDENTITY_FILE_PATH: $IDENTITY_FILE_PATH"
Write-Host "LOCAL_PORT: $LOCAL_PORT"
Write-Host "SERVER_HOST: $SERVER_HOST"
Write-Host "SERVER_PORT: $SERVER_PORT"

# SSH 명령 실행 준비
$sshCommand = "ssh -N -L 0.0.0.0:${LOCAL_PORT}:${SERVER_HOST}:${SERVER_PORT} -i ${IDENTITY_FILE_PATH} ${TUNNEL_SSH_CONFIG} -vv"
Write-Host "명령 실행: $sshCommand"

# SSH 명령 실행
Start-Process -NoNewWindow -Wait -FilePath ssh -ArgumentList @(
    "-N",
    "-L", "0.0.0.0:${LOCAL_PORT}:${SERVER_HOST}:${SERVER_PORT}",
    "-i", "${IDENTITY_FILE_PATH}",
    "${$TUNNEL_SSH_CONFIG}",
    "-vv"
)
