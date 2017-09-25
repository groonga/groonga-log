# -*- mode: ruby; coding: utf-8 -*-
#
# Copyright (C) 2017  Yasuhiro Horimoto <horimoto@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'groonga/log/version'

Gem::Specification.new do |spec|
  spec.name          = "groonga-log"
  spec.version       = Groonga::Log::VERSION

  spec.authors       = ["Horimoto Yasuhiro"]
  spec.email         = ["horimoto@clear-code.com"]

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.homepage      = "https://github.com/groonga/groonga-log"
  spec.licenses      = ["LGPLv2.1+"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
