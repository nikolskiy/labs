from functools import lru_cache
from pydantic import BaseSettings
from typing import List
from pathlib import Path

base_dir = Path(__file__).parent.resolve()
prefix = '/api/v1'

with open(base_dir.joinpath('README.md'), 'r') as f:
    text = f.read()

description = text.format(
    prefix=prefix,
)

origins = [
    "http://localhost",
    "http://localhost:8100",
]


class Settings(BaseSettings):
    api_key: str = 'test_api_key'
    version: str = '0.0.1'

    # application settings
    prefix: str = prefix
    base_dir: Path = base_dir
    description: str = description
    origins: List[str] = origins

    class Config:
        env_file = ".env"


@lru_cache()
def get_settings():
    return Settings()
