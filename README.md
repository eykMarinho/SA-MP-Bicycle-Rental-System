# Sistema de Aluguel de Veículos para SA-MP

<p align="center">
  <img src="https://i.imgur.com/YOUR_IMAGE_HERE.png" alt="Rent Vehicle System" width="600">
</p>

## 📋 Descrição

Sistema profissional de aluguel de veículos para servidores SA-MP. Este sistema permite que jogadores aluguem bicicletas em pontos específicos do mapa, com cobrança por minuto e tempo máximo de uso.

## ✨ Funcionalidades

- Pontos de aluguel configuráveis pelo mapa
- Sistema de cobrança por minuto
- Tempo máximo de aluguel configurável
- Verificação de proximidade para alugar veículos
- Comandos para alugar (`/Alugar`) e devolver (`/Devolver`) veículos
- Texto 3D informativo sobre o veículo alugado
- Ícones no mapa para localizar pontos de aluguel
- Sistema de iteração eficiente para gerenciar jogadores com veículos alugados

## 🛠️ Instalação

1. Baixe o arquivo `RentVehicle.pwn`
2. Coloque-o na pasta `gamemodes` do seu servidor
3. Compile o arquivo usando o compilador Pawn
4. Adicione `RentVehicle` ao seu arquivo `server.cfg` na linha `gamemode0`
5. Certifique-se de ter todas as dependências instaladas (veja abaixo)

## 📦 Dependências

Este sistema requer as seguintes dependências:

### Streamer Plugin v2.9.6 v1.0.0
- Download: [GitHub - samp-incognito/samp-streamer-plugin](https://github.com/samp-incognito/samp-streamer-plugin/releases)
- Instalação: Coloque os arquivos `streamer.dll` (Windows) ou `streamer.so` (Linux) na pasta `plugins` do seu servidor
- Adicione `streamer` à linha `plugins` no seu arquivo `server.cfg`

### YSI-Includes
- Download: [GitHub - pawn-lang/YSI-Includes](https://github.com/pawn-lang/YSI-Includes)
- Instalação: Extraia os arquivos para a pasta `pawno/include` do seu servidor

### Pawn.CMD 3.4.0
- Download: [GitHub - katursis/Pawn.CMD](https://github.com/katursis/Pawn.CMD/releases)
- Instalação: Coloque os arquivos `pawncmd.dll` (Windows) ou `pawncmd.so` (Linux) na pasta `plugins` do seu servidor
- Coloque o arquivo `Pawn.CMD.inc` na pasta `pawno/include` do seu servidor
- Adicione `pawncmd` à linha `plugins` no seu arquivo `server.cfg`

## 🔧 Configuração

Você pode configurar o sistema editando as seguintes constantes no início do arquivo:

```pawn
#define RENT_LIMITS_POINTS      2       // Número de pontos de aluguel
#define RENT_PRICE_PER_MINUTE   50      // Preço por minuto
#define MAX_RENT_TIME           60      // Tempo máximo em minutos
#define RENT_PICKUP_MODEL       1239    // Modelo do pickup
#define RENT_MAPICON_MODEL      55      // Modelo do ícone no mapa
#define RENT_VEHICLE_MODEL      509     // Modelo do veículo (509 = Bicicleta)
#define RENT_VEHICLE_COLOR_ID   3       // Cor do veículo (3 = Vermelho)
```

Para adicionar ou modificar pontos de aluguel, edite o array `RentVehicles`:

```pawn
static RentVehicles[RENT_LIMITS_POINTS][E_RENT_VEHICLE] = 
{
    {126.8853,-77.1170,1.5781},
    {140.7119,-80.0326,1.5781}
};
```

## 📝 Comandos

- `/Alugar` - Aluga uma bicicleta (deve estar próximo a um ponto de aluguel)
- `/Devolver` - Devolve a bicicleta alugada

## 👨‍💻 Desenvolvido por

- MARINHO
- GitHub: [eykMarinho](https://github.com/eykMarinho)
- YouTube: [@eykMarinho](https://www.youtube.com/@eykMarinho)

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.