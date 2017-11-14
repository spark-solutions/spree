class ReturnHandler < YARD::Handlers::Ruby::Base
  handles :return

  def format_args
    args = statement.parameters

    params = []

    if args.unnamed_required_params
      params += args.unnamed_required_params.map {|a| [a.source, nil] }
    end

    if args.unnamed_optional_params
      params += args.unnamed_optional_params.map do |a|
        [a[0].source, a[1].source]
      end
    end

    params << ['*' + args.splat_param.source, nil] if args.splat_param

    if args.unnamed_end_params
      params += args.unnamed_end_params.map {|a| [a.source, nil] }
    end

    if args.named_params
      params += args.named_params.map do |a|
        [a[0].source, a[1] ? a[1].source : nil]
      end
    end

    if args.double_splat_param
      params << ['**' + args.double_splat_param.source, nil]
    end

    params << ['&' + args.block_param.source, nil] if args.block_param

    params
  end

  process do
    puts 'DUPA'
    debugger
  end
end
